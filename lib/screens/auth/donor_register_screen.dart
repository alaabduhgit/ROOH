import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';
import '../../providers/donor_provider.dart';
import '../donor/donor_home.dart';

class DonorRegisterScreen extends StatefulWidget {
  const DonorRegisterScreen({super.key});

  @override
  State<DonorRegisterScreen> createState() => _DonorRegisterScreenState();
}

class _DonorRegisterScreenState extends State<DonorRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _selectedBloodType;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _ageController.dispose();
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
      return 'يرجى إدخال رقم الهاتف';
    }

    final phone = value.trim();

    if (phone.length < 9) {
      return 'رقم الهاتف غير صحيح';
    }

    return null;
  }

  String? _ageValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال العمر';
    }

    final age = int.tryParse(value.trim());

    if (age == null) {
      return 'يرجى إدخال عمر صحيح';
    }

    if (age < 18 || age > 65) {
      return 'عمر المتبرع يجب أن يكون بين 18 و 65';
    }

    return null;
  }

  Future<void> _registerDonor() async {
    if (!_formKey.currentState!.validate()) return;

    final donorProvider = context.read<DonorProvider>();

    await donorProvider.registerDonor(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      bloodType: _selectedBloodType!,
      city: _cityController.text.trim(),
      age: int.parse(_ageController.text.trim()),
    );

    if (!mounted) return;

    if (donorProvider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(donorProvider.errorMessage!)));
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeDonorScreen()),
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
                      'بيانات المتبرع',
                      style: AppTextStyles.title,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    TextFormField(
                      controller: _nameController,
                      textAlign: TextAlign.right,
                      decoration: appInputDecoration(
                        'الاسم الكامل',
                        Icons.person,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          'يرجى إدخال الاسم الكامل',
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _phoneController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.phone,
                      decoration: appInputDecoration('رقم الهاتف', Icons.phone),
                      validator: _phoneValidator,
                    ),

                    const SizedBox(height: 18),

                    DropdownButtonFormField<String>(
                      initialValue: _selectedBloodType,
                      decoration: appInputDecoration(
                        'فصيلة الدم',
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
                      controller: _cityController,
                      textAlign: TextAlign.right,
                      decoration: appInputDecoration(
                        'المدينة',
                        Icons.location_city,
                      ),
                      validator: (value) {
                        return _requiredValidator(value, 'يرجى إدخال المدينة');
                      },
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _ageController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      decoration: appInputDecoration(
                        'العمر',
                        Icons.calendar_month,
                      ),
                      validator: _ageValidator,
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Consumer<DonorProvider>(
                        builder: (context, donorProvider, child) {
                          return ElevatedButton(
                            style: appButtonStyle(),
                            onPressed: donorProvider.isLoading
                                ? null
                                : _registerDonor,
                            child: donorProvider.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'متابعة',
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
