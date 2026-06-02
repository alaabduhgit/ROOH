import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // سطر إضافي للاستماع للمحرك

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';

import '../../providers/patient_provider.dart'; // مسار المحرك الخاص بالمريض
import 'accepted_screen.dart';

class WaitingPatientScreen extends StatelessWidget {
  const WaitingPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الاستماع المستمر للتغيرات الحاصلة في السحاب عبر الـ Provider
    final patientProvider = context.watch<PatientProvider>();

    // لقطة ذكية: إذا تغيرت الحالة في الفايربيس وتم قبول الطلب، انقل المريض لشاشة القبول فوراً تلقائياً
    if (patientProvider.requestAccepted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AcceptedPatientScreen()),
        );
      });
    }

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

                  const Text('تم إرسال الطلب', style: AppTextStyles.title),

                  const SizedBox(height: 40),

                  // دائرة التحميل والانتظار المستمر
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

                  /// زر إلغاء الطلب البرمجي لحذفه من السحاب إذا أراد المريض التراجع
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: appButtonStyle().copyWith(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.red.withOpacity(0.8),
                        ),
                      ),
                      onPressed: () {
                        // استدعاء دالة إلغاء الطلب من الـ Provider
                        context.read<PatientProvider>().cancelRequest();
                        // الرجوع للخلف أو إغلاق الشاشة
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'إلغاء طلب التبرع',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
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
