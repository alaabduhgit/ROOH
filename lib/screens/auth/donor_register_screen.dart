import 'package:flutter/material.dart';

import '/core/widgets/widget.dart';
import '/core/theme/text_styles.dart';

class DonorRegisterScreen extends StatelessWidget {
  const DonorRegisterScreen({super.key});

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
                  const Text("بيانات المتبرع", style: AppTextStyles.title),

                  const SizedBox(height: 40),

                  /// الاسم
                  TextField(
                    decoration: appInputDecoration(
                      "الاسم الكامل",
                      Icons.person,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// الهاتف
                  TextField(
                    keyboardType: TextInputType.phone,

                    decoration: appInputDecoration("رقم الهاتف", Icons.phone),
                  ),

                  const SizedBox(height: 18),

                  /// فصيلة الدم
                  DropdownButtonFormField<String>(
                    decoration: appInputDecoration(
                      "فصيلة الدم",
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

                  /// المدينة
                  TextField(
                    decoration: appInputDecoration(
                      "المدينة",
                      Icons.location_city,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// العمر
                  TextField(
                    keyboardType: TextInputType.number,

                    decoration: appInputDecoration(
                      "العمر",
                      Icons.calendar_month,
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// زر المتابعة
                  SizedBox(
                    width: double.infinity,
                    height: 60,

                    child: ElevatedButton(
                      style: appButtonStyle(),

                      onPressed: () {},

                      child: const Text("متابعة", style: AppTextStyles.button),
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
