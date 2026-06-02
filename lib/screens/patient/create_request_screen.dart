import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';

import '../../providers/patient_provider.dart';
import 'waiting_screen.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  // 1. تعريف الروافع (Controllers) لسحب النصوص المكتوبة في هذه الشاشة
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    hospitalController.dispose();
    locationController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

                  const Text('إنشاء طلب تبرع', style: AppTextStyles.title),

                  const SizedBox(height: 35),

                  AppGlassContainer(
                    child: Column(
                      children: [
                        /// اسم المستشفى
                        TextField(
                          controller: hospitalController, // ربط الرافعة
                          decoration: appInputDecoration(
                            'اسم المستشفى',
                            Icons.local_hospital,
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// الموقع أو العنوان
                        TextField(
                          controller: locationController, // ربط الرافعة
                          decoration: appInputDecoration(
                            'الموقع أو العنوان',
                            Icons.location_on,
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// ملاحظات إضافية
                        TextField(
                          controller: notesController, // ربط الرافعة
                          maxLines: 4,
                          decoration: appInputDecoration(
                            'ملاحظات إضافية',
                            Icons.notes,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white.withOpacity(.15),
                    ),
                    child: const Text(
                      'سيتم إرسال الطلب تلقائياً إلى جميع المتبرعين المطابقين لفصيلة الدم المسجلة في حسابك.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.cardBody,
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: appButtonStyle(),
                      onPressed: () async {
                        // 1. استدعاء الدالة الجديدة التي ترسل بيانات الطلب (المستشفى والموقع)
                        final patientProvider = context.read<PatientProvider>();

                        await patientProvider.sendRequestToDatabase(
                          hospital:
                              hospitalController.text, // النص من الـ Controller
                          location:
                              locationController.text, // النص من الـ Controller
                          notes: notesController.text, // النص من الـ Controller
                        );

                        // 2. الانتقال لشاشة الانتظار
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WaitingPatientScreen(),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.send),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text('إرسال الطلب', style: AppTextStyles.button),
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
