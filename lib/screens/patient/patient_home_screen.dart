import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';
import '../../providers/patient_provider.dart';
import '../auth/choose_role_screen.dart';
import 'create_request_screen.dart';
import 'patient_profile_screen.dart';
import 'waiting_screen.dart';

class HomePatientScreen extends StatelessWidget {
  const HomePatientScreen({super.key});

  void _goToCreateRequest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateRequestScreen()),
    );
  }

  void _goToWaitingScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WaitingPatientScreen()),
    );
  }

  void _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PatientProfileScreen()),
    );
  }

  Future<void> _deleteAccount(
    BuildContext context,
    PatientProvider provider,
  ) async {
    await provider.logoutAndDestroyAccount();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
      (route) => false,
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    PatientProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
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
              'هل أنت متأكد من رغبتك في حذف حسابك وكافة بياناتك؟ لا يمكن التراجع عن هذا الإجراء.',
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
              ElevatedButton(
                style: appButtonStyle(),
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await _deleteAccount(context, provider);
                },
                child: const Text(
                  'نعم، احذف نهائياً',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<PatientProvider>(
        builder: (context, patientProvider, child) {
          final patient = patientProvider.currentPatient;

          return Scaffold(
            body: AppBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'لوحة المحتاج',
                        style: AppTextStyles.title,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 35),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'بيانات الحالة',
                              style: AppTextStyles.cardTitle,
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 16),
                            _InfoLine(
                              icon: Icons.person,
                              title: 'الاسم',
                              value: patient.name.isEmpty
                                  ? 'غير محدد'
                                  : patient.name,
                            ),
                            const SizedBox(height: 12),
                            _InfoLine(
                              icon: Icons.bloodtype,
                              title: 'فصيلة الدم',
                              value: patient.bloodType.isEmpty
                                  ? 'غير محدد'
                                  : patient.bloodType,
                            ),
                            const SizedBox(height: 12),
                            _InfoLine(
                              icon: Icons.phone,
                              title: 'رقم التواصل',
                              value: patient.phone.isEmpty
                                  ? 'غير محدد'
                                  : patient.phone,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          style: appButtonStyle(),
                          onPressed: patientProvider.hasActiveRequest
                              ? () => _goToWaitingScreen(context)
                              : () => _goToCreateRequest(context),
                          icon: Icon(
                            patientProvider.hasActiveRequest
                                ? Icons.hourglass_top
                                : Icons.add_circle_outline,
                            color: AppColors.white,
                          ),
                          label: Text(
                            patientProvider.hasActiveRequest
                                ? 'متابعة الطلب الحالي'
                                : 'إنشاء طلب تبرع',
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () => _goToProfile(context),
                          icon: const Icon(
                            Icons.person_rounded,
                            color: AppColors.primary,
                          ),
                          label: const Text(
                            'الملف الشخصي',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: TextButton.icon(
                          onPressed: () {
                            _showDeleteConfirmationDialog(
                              context,
                              patientProvider,
                            );
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: AppColors.primary,
                          ),
                          label: const Text(
                            'حذف الحساب',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoLine({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 10),
        Text(
          '$title: ',
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontFamily: 'Cairo', color: AppColors.black),
          ),
        ),
      ],
    );
  }
}
