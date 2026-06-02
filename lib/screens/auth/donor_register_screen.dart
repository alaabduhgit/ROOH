import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/widgets/widget.dart';
import '/core/theme/text_styles.dart';
import '../../providers/donor_provider.dart';
import '../donor/donor_home.dart';

class DonorRegisterScreen extends StatefulWidget {
  const DonorRegisterScreen({super.key});

  @override
  State<DonorRegisterScreen> createState() => _DonorRegisterScreenState();
}

class _DonorRegisterScreenState extends State<DonorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _ageController = TextEditingController();

  String? _selectedBloodType;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    super.dispose();
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
                    const Text("بيانات المتبرع", style: AppTextStyles.title),

                    const SizedBox(height: 40),

                    /// الاسم
                    TextFormField(
                      controller: _nameController,
                      decoration: appInputDecoration(
                        "الاسم الكامل",
                        Icons.person,
                      ),
                      validator: (value) =>
                          _requiredValidator(value, 'يرجى إدخال الاسم الكامل'),
                    ),

                    const SizedBox(height: 18),

                    /// الهاتف
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: appInputDecoration("رقم الهاتف", Icons.phone),
                      validator: _phoneValidator,
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

                    /// المدينة
                    TextFormField(
                      controller: _cityController,
                      decoration: appInputDecoration(
                        "المدينة",
                        Icons.location_city,
                      ),
                      validator: (value) =>
                          _requiredValidator(value, 'يرجى إدخال المدينة'),
                    ),

                    const SizedBox(height: 18),

                    /// العمر
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: appInputDecoration(
                        "العمر",
                        Icons.calendar_month,
                      ),
                      validator: _ageValidator,
                    ),

                    const SizedBox(height: 35),

                    /// زر المتابعة
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
                                    "متابعة",
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
        ],
      ),
    );
  }
}
