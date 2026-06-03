import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';
import '../../providers/patient_provider.dart';
import '../../services/patient_service.dart';
import 'accepted_screen.dart';

class WaitingPatientScreen extends StatelessWidget {
  const WaitingPatientScreen({super.key});

  void _handleAcceptedRequest({
    required BuildContext context,
    required PatientProvider patientProvider,
    required Map<String, dynamic> acceptedData,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      patientProvider.acceptRequest(
        donorName: acceptedData['acceptedByDonorName']?.toString() ?? '',
        donorPhone: acceptedData['acceptedByDonorPhone']?.toString() ?? '',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AcceptedPatientScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = context.watch<PatientProvider>();
    final patientService = PatientService();
    final patientId = patientProvider.currentPatient.id;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: patientId.isEmpty
                  ? const Stream<QuerySnapshot<Map<String, dynamic>>>.empty()
                  : patientService.getPatientRequests(patientId),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  final acceptedRequests = snapshot.data!.docs.where((doc) {
                    final data = doc.data();
                    return data['status'] == 'accepted';
                  }).toList();

                  if (acceptedRequests.isNotEmpty &&
                      !patientProvider.requestAccepted) {
                    _handleAcceptedRequest(
                      context: context,
                      patientProvider: patientProvider,
                      acceptedData: acceptedRequests.first.data(),
                    );
                  }
                }

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      appBackButton(context),

                      const SizedBox(height: 30),

                      const Text(
                        'تم إرسال الطلب',
                        style: AppTextStyles.title,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(.08),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'جاري البحث عن متبرع',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'سيتم إشعارك فور قبول أحد المتبرعين للطلب.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.cardBody,
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          style: appButtonStyle().copyWith(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.red.withOpacity(.82),
                            ),
                          ),
                          onPressed: patientProvider.isLoading
                              ? null
                              : () async {
                                  await patientProvider.cancelRequest();

                                  if (!context.mounted) return;

                                  Navigator.pop(context);
                                },
                          icon: const Icon(Icons.cancel, color: Colors.white),
                          label: const Text(
                            'إلغاء طلب التبرع',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
