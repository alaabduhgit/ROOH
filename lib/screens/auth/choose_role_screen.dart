import 'package:flutter/material.dart';

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';

import 'donor_register_screen.dart';
import 'patient_register_screen.dart';
import 'blood_info_screen.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// الخلفية
          Positioned.fill(
            child: Image.asset('assets/bg.png', fit: BoxFit.cover),
          ),

          /// طبقة شفافة
          Container(color: Colors.white.withOpacity(.08)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                children: [
                  /// زر الرجوع
                  appBackButton(context),

                  const Spacer(),

                  /// العنوان
                  const Text("اختر نوع الحساب", style: AppTextStyles.title),

                  const SizedBox(height: 50),

                  /// زر المتبرع
                  SizedBox(
                    width: double.infinity,
                    height: 60,

                    child: ElevatedButton(
                      style: appButtonStyle(),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DonorRegisterScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        "مستعد للتبرع",
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// زر المحتاج
                  SizedBox(
                    width: double.infinity,
                    height: 60,

                    child: ElevatedButton(
                      style: appButtonStyle(),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PatientRegisterScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        "أحتاج لدم",
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),

                  const SizedBox(height: 45),

                  /// ثقف نفسك
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BloodInfoScreen(),
                        ),
                      );
                    },

                    child: Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.92),

                        borderRadius: BorderRadius.circular(25),
                      ),

                      child: const Column(
                        children: [
                          Text(
                            "ثقف نفسك قبل التبرع",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),

                          SizedBox(height: 12),

                          Text(
                            "اضغط لمعرفة كل ما يخص الدم والتبرع",
                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
