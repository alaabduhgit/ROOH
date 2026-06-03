import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/widgets/widget.dart';
import '../../providers/donor_provider.dart';
import '../../providers/patient_provider.dart';
import '../../services/local_storage_service.dart';
import '../donor/donor_home.dart';
import '../patient/patient_home_screen.dart';
import 'choose_role_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _continue(BuildContext context) async {
    final localStorageService = LocalStorageService();

    final activeUserId = await localStorageService.getActiveUserId();
    final activeUserRole = await localStorageService.getActiveUserRole();

    if (!context.mounted) return;

    if (activeUserId == null ||
        activeUserId.isEmpty ||
        activeUserRole == null ||
        activeUserRole.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
      );
      return;
    }

    if (activeUserRole == 'donor') {
      await context.read<DonorProvider>().loadDonorById(activeUserId);

      if (!context.mounted) return;

      final donorProvider = context.read<DonorProvider>();

      if (donorProvider.currentDonor.id.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeDonorScreen()),
      );
      return;
    }

    if (activeUserRole == 'patient') {
      await context.read<PatientProvider>().loadPatientById(activeUserId);

      if (!context.mounted) return;

      final patientProvider = context.read<PatientProvider>();

      if (patientProvider.currentPatient.id.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePatientScreen()),
      );
      return;
    }

    await localStorageService.clearSession();

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        imagePath: 'assets/welcome_bg.png',
        overlayColor: Colors.black.withOpacity(.10),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: appForwardButton(onPressed: () => _continue(context)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
