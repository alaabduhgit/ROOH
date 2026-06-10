import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';
import '../../providers/donor_provider.dart';
import '../auth/blood_info_screen.dart';
import '../auth/choose_role_screen.dart';
import 'widgets/donor_widgets.dart';

class ControlDonorScreen extends StatelessWidget {
  const ControlDonorScreen({super.key});

  Future<void> _deleteAccount(
    BuildContext Context,
    DonorProvider provider,
  ) async {
    await provider.logoutAndDestroyAccount();

    if (!Context.mounted) return;

    Navigator.pushAndRemoveUntil(
      Context,
      MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
      (route) => false,
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    DonorProvider provider,
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
              'هل أنت متأكد من رغبتك في تسجيل الخروج وحذف كافة بياناتك نهائياً من النظام؟ لا يمكن التراجع عن هذا الإجراء.',
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
      child: Scaffold(
        extendBody: true,
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
                    'التحكم بالحالة',
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  AppGlassContainer(
                    child: Consumer<DonorProvider>(
                      builder: (context, provider, child) {
                        final donor = provider.currentDonor;
                        final readiness = provider.donationReadiness;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DonorMenuRow(
                              icon: Icons.cached,
                              title: 'التحكم بالحالة للجاهزية',
                              trailing: Switch(
                                onChanged: readiness == 100
                                    ? provider.toggleAvailability
                                    : null,
                                value: readiness == 100
                                    ? donor.isAvailable
                                    : false,
                                activeColor: AppColors.primary,
                              ),
                            ),
                            const Divider(color: Colors.white54),
                            DonorMenuRow(
                              icon: Icons.menu_book,
                              title: 'ثقف نفسك',
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primary,
                                size: 16,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const BloodInfoScreen(),
                                  ),
                                );
                              },
                            ),
                            const Divider(color: Colors.white54),
                            DonorMenuRow(
                              icon: Icons.delete_forever,
                              title: 'تسجيل الخروج وحذف الحساب',
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primary,
                                size: 16,
                              ),
                              onTap: () {
                                _showDeleteConfirmationDialog(
                                  context,
                                  provider,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const DonorBottomNav(currentIndex: 0),
      ),
    );
  }
}
