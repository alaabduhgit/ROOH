import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/welcome_screen.dart';

// استدعاء ملفات صديقاتكِ (تم تعليقها مؤقتاً)
import 'providers/donor_provider.dart';
import 'screens/donor/donor_home.dart';

// استدعاء ملفاتكِ الخاصة بـ (المحتاج / Patient)
import 'providers/patient_provider.dart';
import 'screens/patient/patient_home_screen.dart';
import 'package:firebase_core/firebase_core.dart'; // هذه لاستدعاء مكتبة الفايربيس الأساسية
import 'firebase_options.dart'; // هذه لاستدعاء ملف الإعدادات الذي أنشأناه في الخطوة السابقة

void main() async {
  // 1. أضفنا async
  WidgetsFlutterBinding.ensureInitialized(); // 2. تهيئة النظام
  await Firebase.initializeApp(
    // 3. الاتصال بـ Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // هنا أضيفي runApp:
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => DonorProvider()),
      ],
      child: const MyApp(),
    ),
  ); // وهنا أغلقي القوس
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      // الشاشة الرئيسية الموجهة لشاشتكِ لتجربتها مباشرة:
      // home: HomePatientScreen(),

      // أسطر التحكم السابقة (معلقة مؤقتاً)
      home: WelcomeScreen(),
      // home: HomeDonorScreen(),
    );
  }
}
