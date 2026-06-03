import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';
import '../../providers/patient_provider.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientProvider = context.watch<PatientProvider>();
    final patient = patientProvider.currentPatient;

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
                    'الملف الشخصي',
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 35),

                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(.10),
                      border: Border.all(color: AppColors.primary, width: 3),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 58,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        _ProfileLine(
                          icon: Icons.person,
                          title: 'الاسم',
                          value: patient.name.isEmpty
                              ? 'غير محدد'
                              : patient.name,
                        ),
                        const Divider(height: 26),
                        _ProfileLine(
                          icon: Icons.bloodtype,
                          title: 'فصيلة الدم',
                          value: patient.bloodType.isEmpty
                              ? 'غير محدد'
                              : patient.bloodType,
                        ),
                        const Divider(height: 26),
                        _ProfileLine(
                          icon: Icons.phone,
                          title: 'رقم التواصل',
                          value: patient.phone.isEmpty
                              ? 'غير محدد'
                              : patient.phone,
                        ),
                        const Divider(height: 26),
                        _ProfileLine(
                          icon: Icons.medical_services,
                          title: 'عدد الطلبات',
                          value: patient.totalRequests.toString(),
                        ),
                      ],
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

class _ProfileLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileLine({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 23),
        const SizedBox(width: 12),
        Text(
          '$title: ',
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontFamily: 'Cairo', color: AppColors.black),
          ),
        ),
      ],
    );
  }
}
