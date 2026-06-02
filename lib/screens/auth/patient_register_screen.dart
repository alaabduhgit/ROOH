import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/widgets/widget.dart';
import '/core/theme/text_styles.dart';
import '../patient/patient_home_screen.dart'; // مسار الملف الحقيقي المعتمد عندكِ
import '../../providers/patient_provider.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  State<PatientRegisterScreen> createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _bagsController = TextEditingController();

  String? _selectedBloodType = "O+"; // القيمة الافتراضية للفصيلة

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _hospitalController.dispose();
    _bagsController.dispose();
    super.dispose();
  }

  // الدالة المسؤولة عن فحص الحقول وإرسال طلب المحتاج للسحاب
  Future<void> _registerPatient() async {
    if (!_formKey.currentState!.validate()) return;

    final patientProvider = context.read<PatientProvider>();

    await patientProvider.createRequest(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      bloodType: _selectedBloodType!,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePatientScreen()),
    );
  }

  // نفس دالات التحقق الذكية الخاصة بكِ يا نور لمنع الغلط والخطوط الحمراء
  String? _requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }

    final phone = value.trim();

    if (phone.length < 9) {
      return 'رقم الهاتف غير صحيح';
    }

    return null;
  }

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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// زر الرجوع
                    appBackButton(context),

                    const SizedBox(height: 20),

                    /// العنوان
                    const Text("بيانات المحتاج", style: AppTextStyles.title),

                    const SizedBox(height: 40),

                    /// اسم المريض
                    TextFormField(
                      controller: _nameController,
                      decoration: appInputDecoration(
                        "اسم المريض",
                        Icons.person,
                      ),
                      validator: (value) =>
                          _requiredValidator(value, 'يرجى إدخال اسم المريض'),
                    ),

                    const SizedBox(height: 18),

                    /// رقم التواصل
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: appInputDecoration(
                        "رقم التواصل",
                        Icons.phone,
                      ),
                      validator: _phoneValidator,
                    ),

                    const SizedBox(height: 18),

                    /// فصيلة الدم المطلوبة
                    DropdownButtonFormField<String>(
                      value: _selectedBloodType,
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
                      onChanged: (value) {
                        setState(() {
                          _selectedBloodType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى اختيار فصيلة الدم';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    /// اسم المستشفى
                    TextFormField(
                      controller: _hospitalController,
                      decoration: appInputDecoration(
                        "اسم المستشفى",
                        Icons.local_hospital,
                      ),
                      validator: (value) =>
                          _requiredValidator(value, 'يرجى إدخال اسم المستشفى'),
                    ),

                    const SizedBox(height: 18),

                    /// عدد الأكياس المطلوبة
                    TextFormField(
                      controller: _bagsController,
                      keyboardType: TextInputType.number,
                      decoration: appInputDecoration(
                        "عدد الأكياس المطلوبة",
                        Icons.medical_services,
                      ),
                      validator: (value) =>
                          _requiredValidator(value, 'يرجى إدخال عدد الأكياس'),
                    ),

                    const SizedBox(height: 35),

                    /// زر الإرسال
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: appButtonStyle(),
                        onPressed: _registerPatient,
                        child: const Text("إرسال", style: AppTextStyles.button),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
