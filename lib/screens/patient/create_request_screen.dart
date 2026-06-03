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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _hospitalController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }

  Future<void> _sendRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final patientProvider = context.read<PatientProvider>();

    await patientProvider.sendRequestToDatabase(
      hospital: _hospitalController.text.trim(),
      location: _locationController.text.trim(),
      notes: _notesController.text.trim(),
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
      MaterialPageRoute(builder: (_) => const WaitingPatientScreen()),
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
                      'إنشاء طلب تبرع',
                      style: AppTextStyles.title,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

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
                      controller: _locationController,
                      textAlign: TextAlign.right,
                      decoration: appInputDecoration(
                        'الموقع أو العنوان',
                        Icons.location_on,
                      ),
                      validator: (value) {
                        return _requiredValidator(
                          value,
                          'يرجى إدخال الموقع أو العنوان',
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _notesController,
                      textAlign: TextAlign.right,
                      minLines: 3,
                      maxLines: 5,
                      decoration: appInputDecoration(
                        'ملاحظات إضافية',
                        Icons.notes,
                      ),
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
                                : _sendRequest,
                            child: patientProvider.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'إرسال الطلب',
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
