import 'package:flutter/material.dart';
import 'screens/auth/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'providers/donor_provider.dart';
import 'screens/donor/donor_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      // home: HomeDonorScreen(),
    );
  }
}
