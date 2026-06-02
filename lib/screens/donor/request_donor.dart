import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';
import '../../providers/donor_provider.dart';

class RequestDonorScreen extends StatelessWidget {
  final Map<String, dynamic> requestDetails;

  const RequestDonorScreen({super.key, required this.requestDetails});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DonorProvider>(context, listen: false);

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
                  /// زر الرجوع
                  appBackButton(context),
                  const SizedBox(height: 20),
                  const Text('تفاصيل طلب التبرع', style: AppTextStyles.title),
                  const SizedBox(height: 30),

                  /// دائرة فصيلة الدم
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
                        requestDetails['bloodType'] ?? 'غير معروف',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// الكارد الأبيض المخصص لعرض تفاصيل المريض الحقيقية من السحاب
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. اسم المريض أو المستشفى
                        _buildDetailRow(
                          icon: Icons.local_hospital,
                          title: 'المستشفى / الجهة:',
                          value:
                              requestDetails['hospitalName'] ??
                              requestDetails['hospital'] ??
                              'غير محدد',
                        ),
                        const Divider(height: 24),

                        // 2. الموقع أو العنوان
                        _buildDetailRow(
                          icon: Icons.location_on,
                          title: 'الموقع أو العنوان:',
                          value:
                              requestDetails['location'] ??
                              'تعز - المركز الرئيسي',
                        ),
                        const Divider(height: 24),

                        // 3. ملاحظات المريض
                        _buildDetailRow(
                          icon: Icons.notes,
                          title: 'ملاحظات إضافية:',
                          value:
                              requestDetails['notes'] ??
                              'طلب عاجل يرجى التواصل سريعاً.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// أزرار التحكم (قبول / رفض)
                  Row(
                    children: [
                      // زر قبول الطلب
                      Expanded(
                        child: ElevatedButton.icon(
                          style: appButtonStyle().copyWith(
                            backgroundColor: WidgetStateProperty.all(
                              AppColors.primary,
                            ),
                          ),
                          onPressed: () async {
                            // استدعاء دالة القبول من الـ Provider
                            await provider.acceptBloodRequest(
                              requestDetails['id'] ?? '',
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'تم قبول طلب التبرع بنجاح، جاري التواصل.',
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: const Text(
                            'قبول الطلب',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Cairo',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // زر رفض الطلب
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            provider.rejectBloodRequest(
                              requestDetails['id'] ?? '',
                            );
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close, color: Colors.grey),
                          label: const Text(
                            'تجاهل',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Cairo',
                              fontSize: 16,
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

  /// دالة مساعدة لترتيب أسطر البيانات بشكل نظيف
  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
