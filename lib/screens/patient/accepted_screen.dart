import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart'; // تأكدي من مسمى الملف لديكِ سواءً .dart أو .yaml ليعمل الاستيراد

import '../../providers/patient_provider.dart';
import 'patient_home_screen.dart';

class AcceptedPatientScreen extends StatelessWidget {
  const AcceptedPatientScreen({super.key});

  // الدالة الفعالة لفتح واجهة الاتصال في الهاتف مباشرة
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // تفادي الفشل في حال عدم وجود تطبيق اتصال
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PatientProvider>(
      context,
      listen: false,
    );

    // جلب البيانات من الموديل والبروفايدر مع وضع قيم احتياطية
    final String donorPhone = provider.donorPhone.isEmpty ? '777123456' : provider.donorPhone;
    final String donorName = provider.donorName.isEmpty ? 'أحمد محمد' : provider.donorName;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 110,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'تم العثور على متبرع',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.title,
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'اسم المتبرع',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontFamily: 'Cairo',
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          donorName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'رقم التواصل',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontFamily: 'Cairo',
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          donorPhone,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // زر التواصل الفعال والمربوط بالنظام
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () => _makePhoneCall(donorPhone),
                      icon: const Icon(Icons.phone),
                      label: const Text(
                        'التواصل مع المتبرع',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: appButtonStyle(),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomePatientScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home),
                      label: const Text(
                        'العودة للرئيسية',
                        style: AppTextStyles.button,
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