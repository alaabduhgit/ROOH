import 'package:flutter/material.dart';

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';

import 'accepted_screen.dart';

class WaitingPatientScreen extends StatelessWidget {
  const WaitingPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  appBackButton(context),

                  const SizedBox(height: 30),

                  const Text(
                    'تم إرسال الطلب',
                    style: AppTextStyles.title,
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

                  /// مؤقت فقط أثناء التطوير
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: appButtonStyle(),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const AcceptedPatientScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'محاكاة قبول الطلب',
                          style: AppTextStyles.button,
                        ),
                      ),
                    ),
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