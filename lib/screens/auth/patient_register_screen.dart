import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';
import '../../providers/patient_provider.dart';
import '../patient/patient_home_screen.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  State<PatientRegisterScreen> createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _bagsController = TextEditingController();

  String? _selectedBloodType = 'O+';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _hospitalController.dispose();
    _bagsController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رقم التواصل';
    }

    final phone = value.trim();

    if (phone.length < 9) {
      return 'رقم التواصل غير صحيح';
    }

    return null;
  }

  Future<void> _registerPatient() async {
    if (!_formKey.currentState!.validate()) return;

    final patientProvider = context.read<PatientProvider>();

    await patientProvider.createRequest(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      bloodType: _selectedBloodType!,
    );

    if (!mounted) return;

    if (patientProvider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(patientProvider.errorMessage!)));
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePatientScreen()),
    );
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    appBackButton(context),

                    const SizedBox(height: 20),

                    const Text(
                      'بيانات المحتاج',
                      style: AppTextStyles.title,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    TextFormField(
                      controller: _nameController,
                      textAlign: TextAlign.right,
                      decoration: appInputDecoration(
                        'اسم المريض',
                        Icons.person,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          'يرجى إدخال اسم المريض',
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _phoneController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.phone,
                      decoration: appInputDecoration(
                        'رقم التواصل',
                        Icons.phone,
                      ),
                      validator: _phoneValidator,
                    ),

                    const SizedBox(height: 18),

                    DropdownButtonFormField<String>(
                      initialValue: _selectedBloodType,
                      decoration: appInputDecoration(
                        'فصيلة الدم المطلوبة',
                        Icons.bloodtype,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'A+', child: Text('A+')),
                        DropdownMenuItem(value: 'A-', child: Text('A-')),
                        DropdownMenuItem(value: 'B+', child: Text('B+')),
                        DropdownMenuItem(value: 'B-', child: Text('B-')),
                        DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                        DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                        DropdownMenuItem(value: 'O+', child: Text('O+')),
                        DropdownMenuItem(value: 'O-', child: Text('O-')),
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

                    TextFormField(
                      controller: _hospitalController,
                      textAlign: TextAlign.right,
                      decoration: appInputDecoration(
                        'اسم المستشفى',
                        Icons.local_hospital,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          'يرجى إدخال اسم المستشفى',
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _bagsController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      decoration: appInputDecoration(
                        'عدد الأكياس المطلوبة',
                        Icons.medical_services,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          'يرجى إدخال عدد الأكياس',
                        );
                      },
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Consumer<PatientProvider>(
                        builder: (context, patientProvider, child) {
                          return ElevatedButton(
                            style: appButtonStyle(),
                            onPressed: patientProvider.isLoading
                                ? null
                                : _registerPatient,
                            child: patientProvider.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'إرسال',
                                    style: AppTextStyles.button,
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
