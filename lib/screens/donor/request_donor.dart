import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';
import '../../providers/donor_provider.dart';
import 'widgets/donor_widgets.dart';

class RequestDonorScreen extends StatelessWidget {
  final Map<String, dynamic> requestDetails;

  const RequestDonorScreen({super.key, required this.requestDetails});

  String _readValue(String key, String fallback) {
    final value = requestDetails[key];

    if (value == null) return fallback;

    final text = value.toString().trim();

    return text.isEmpty ? fallback : text;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DonorProvider>(context, listen: false);

    final requestId = _readValue('id', '');
    final bloodType = _readValue('bloodType', 'غير معروف');
    final patientName = _readValue('patientName', 'مريض بحاجة لدعمكم');
    final hospital = _readValue('hospital', 'غير محدد');
    final location = _readValue('location', 'غير محدد');
    final notes = _readValue('notes', 'لا توجد ملاحظات');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  appBackButton(context),

                  const SizedBox(height: 20),

                  const Text(
                    'تفاصيل طلب التبرع',
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.10),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        bloodType,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'فصيلة الدم المطلوبة',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Cairo',
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        DonorInfoRow(
                          icon: Icons.person_pin,
                          title: 'اسم الحالة:',
                          value: patientName,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1),
                        ),
                        DonorInfoRow(
                          icon: Icons.local_hospital,
                          title: 'مكان التبرع:',
                          value: hospital,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1),
                        ),
                        DonorInfoRow(
                          icon: Icons.location_on,
                          title: 'الموقع:',
                          value: location,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1),
                        ),
                        DonorInfoRow(
                          icon: Icons.notes,
                          title: 'ملاحظات:',
                          value: notes,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 45),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);

                            await provider.acceptBloodRequest(requestId);

                            if (!context.mounted) return;

                            Navigator.pop(context);

                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'تم قبول الطلب، شكراً لإنقاذك حياة!',
                                  style: TextStyle(fontFamily: 'Cairo'),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text(
                            'نعم، أوافق',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () async {
                            await provider.rejectBloodRequest(requestId);

                            if (!context.mounted) return;

                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text(
                            'لا، تخطى',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
