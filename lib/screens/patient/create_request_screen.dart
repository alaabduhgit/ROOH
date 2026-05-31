import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';

import '../../providers/patient_provider.dart';
import 'waiting_screen.dart';

class CreateRequestScreen extends StatelessWidget {
  const CreateRequestScreen({super.key});

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

                  const Text(
                    'إنشاء طلب تبرع',
                    style: AppTextStyles.title,
                  ),

                  const SizedBox(height: 35),

                  AppGlassContainer(
                    child: Column(
                      children: [
                        TextField(
                          decoration: appInputDecoration(
                            'اسم المستشفى',
                            Icons.local_hospital,
                          ),
                        ),

                        const SizedBox(height: 18),

                        TextField(
                          decoration: appInputDecoration(
                            'الموقع أو العنوان',
                            Icons.location_on,
                          ),
                        ),

                        const SizedBox(height: 18),

                        TextField(
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
                      onPressed: () {
                        context.read<PatientProvider>().createRequest();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const WaitingPatientScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'إرسال الطلب',
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