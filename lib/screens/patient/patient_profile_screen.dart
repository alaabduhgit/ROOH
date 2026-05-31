import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';

import '../../providers/patient_provider.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBody: true,
        body: AppBackground(
          child: SafeArea(
            child: Consumer<PatientProvider>(
              builder: (context, provider, child) {
                final patient = provider.currentPatient;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'الحساب الشخصي',
                        style: AppTextStyles.title,
                      ),

                      const SizedBox(height: 30),

                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          // التعديل والإصلاح للموديل هنا باستخدام withValues المستقرة حديثاً
                          color: AppColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          size: 60,
                          Icons.person,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.person,
                              title: 'الاسم',
                              value: patient.name,
                            ),

                            const Divider(),

                            _InfoRow(
                              icon: Icons.bloodtype,
                              title: 'فصيلة الدم',
                              value: patient.bloodType,
                            ),

                            const Divider(),

                            _InfoRow(
                              icon: Icons.phone,
                              title: 'رقم التواصل',
                              value: patient.phone,
                            ),

                            const Divider(),

                            _InfoRow(
                              icon: Icons.history,
                              title: 'عدد الطلبات السابقة',
                              value: patient.totalRequests.toString(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.assignment,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'حالة الطلب',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  provider.hasActiveRequest ? 'نشط' : 'لا يوجد',
                                  style: TextStyle(
                                    color: provider.hasActiveRequest
                                        ? Colors.green
                                        : AppColors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),

                            if (provider.requestAccepted) ...[
                              const Divider(height: 30),

                              _InfoRow(
                                icon: Icons.person_outline,
                                title: 'اسم المتبرع',
                                value: provider.donorName,
                              ),

                              const Divider(height: 30),

                              _InfoRow(
                                icon: Icons.phone_enabled,
                                title: 'رقم المتبرع',
                                value: provider.donorPhone,
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 35),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: appButtonStyle(),
                          onPressed: () {
                            _showDeleteConfirmationDialog(
                              context,
                              provider,
                            );
                          },
                          icon: const Icon(Icons.delete_forever),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            child: Text(
                              'تسجيل الخروج وحذف الحساب',
                              style: AppTextStyles.button,
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

  void _showDeleteConfirmationDialog(
    BuildContext context,
    PatientProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Text(
            'تأكيد الحذف النهائي',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          content: const Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج وحذف كافة بياناتك نهائياً من النظام؟ لا يمكن التراجع عن هذا الإجراء.',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
            ),
            ElevatedButton(
              style: appButtonStyle(),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await provider.logoutAndDestroyAccount();
              },
              child: const Text(
                'نعم، احذف نهائياً',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}