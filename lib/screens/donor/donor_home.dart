import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';
import '../../services/patient_service.dart';
import 'request_donor.dart';
import 'widgets/donor_widgets.dart';

class HomeDonorScreen extends StatelessWidget {
  const HomeDonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PatientService _patientService = PatientService();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: const Drawer(),
        extendBody: true,
        body: AppBackground(
          child: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
              stream: _patientService.getPatients(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.hasData ? snapshot.data!.docs : [];

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('لوحة المتبرع', style: AppTextStyles.title),
                      const SizedBox(height: 28),
                      _buildHeaderCard(),
                      const SizedBox(height: 25),
                      Expanded(
                        child: ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            // نتعامل هنا مع الـ Map مباشرة لضمان عدم وجود أخطاء في التمرير
                            final data =
                                docs[index].data() as Map<String, dynamic>;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  child: Text(
                                    data['bloodType'] ?? '',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(data['name'] ?? 'مريض'),
                                subtitle: Text(data['hospital'] ?? ''),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      // نمرر الـ data مباشرة، وتأكدي أن RequestDonorScreen يستقبل dynamic أو Map
                                      builder: (_) => RequestDonorScreen(
                                        requestDetails: data,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: const DonorBottomNav(currentIndex: 2),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Text(
        "شكراً لك، عملك النبيل ينقذ الأرواح!",
        textAlign: TextAlign.center,
      ),
    );
  }
}
