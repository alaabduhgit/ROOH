import 'package:flutter/material.dart';

import '/core/widgets/widget.dart';
import '/core/theme/text_styles.dart';

class PatientRegisterScreen extends StatelessWidget {
  const PatientRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/bg.png', fit: BoxFit.cover),
          ),

          Container(color: Colors.white.withOpacity(.08)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                children: [
                  /// زر الرجوع
                  appBackButton(context),

                  const SizedBox(height: 20),

                  /// العنوان
                  const Text("بيانات المحتاج", style: AppTextStyles.title),

                  const SizedBox(height: 40),

                  /// اسم المريض
                  TextField(
                    decoration: appInputDecoration("اسم المريض", Icons.person),
                  ),

                  const SizedBox(height: 18),

                  /// رقم التواصل
                  TextField(
                    keyboardType: TextInputType.phone,

                    decoration: appInputDecoration("رقم التواصل", Icons.phone),
                  ),

                  const SizedBox(height: 18),

                  /// فصيلة الدم
                  DropdownButtonFormField<String>(
                    decoration: appInputDecoration(
                      "فصيلة الدم المطلوبة",
                      Icons.bloodtype,
                    ),

                    items: const [
                      DropdownMenuItem(value: "A+", child: Text("A+")),

                      DropdownMenuItem(value: "A-", child: Text("A-")),

                      DropdownMenuItem(value: "B+", child: Text("B+")),

                      DropdownMenuItem(value: "B-", child: Text("B-")),

                      DropdownMenuItem(value: "AB+", child: Text("AB+")),

                      DropdownMenuItem(value: "AB-", child: Text("AB-")),

                      DropdownMenuItem(value: "O+", child: Text("O+")),

                      DropdownMenuItem(value: "O-", child: Text("O-")),
                    ],

                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 18),

                  /// المستشفى
                  TextField(
                    decoration: appInputDecoration(
                      "اسم المستشفى",
                      Icons.local_hospital,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// عدد الأكياس
                  TextField(
                    keyboardType: TextInputType.number,

                    decoration: appInputDecoration(
                      "عدد الأكياس المطلوبة",
                      Icons.medical_services,
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// زر الإرسال
                  SizedBox(
                    width: double.infinity,
                    height: 60,

                    child: ElevatedButton(
                      style: appButtonStyle(),

                      onPressed: () {},

                      child: const Text("إرسال", style: AppTextStyles.button),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
