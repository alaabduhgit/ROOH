import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';
import '../../providers/patient_provider.dart';
import 'create_request_screen.dart'; 
import 'patient_profile_screen.dart'; // استيراد ملف البروفايل ليعمل زر الانتقال

class HomePatientScreen extends StatelessWidget {
  const HomePatientScreen({super.key});

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
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'لوحة المحتاج',
                            style: AppTextStyles.title,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.account_circle,
                              size: 32,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PatientProfileScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      
                      // 1. بطاقة الترحيب 
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: AppColors.primary,
                              size: 45,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'مرحباً ${patient.name}',
                              style: AppTextStyles.cardTitle,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'يمكنك إنشاء طلب تبرع جديد في أي وقت.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      // 2. بطاقة فصيلة الدم 
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.bloodtype,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'فصيلة الدم',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const Spacer(),
                            Text(
                              patient.bloodType,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      // 3. بطاقة حالة الطلب  
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
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
                              provider.hasActiveRequest ? 'جاري البحث' : 'لا يوجد طلب',
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
                      ),
                      
                      const Spacer(),
                      
                      // 4. زر إنشاء الطلب (يختفي ذكياً إذا كان هناك طلب نشط جاري البحث عنه)
                      if (!provider.hasActiveRequest)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: appButtonStyle(),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreateRequestScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                'إنشاء طلب جديد',
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
}