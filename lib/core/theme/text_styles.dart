import 'package:flutter/material.dart';
import 'light_theme.dart';

class AppTextStyles {
  /// العناوين الرئيسية
  static const TextStyle title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  /// النصوص العادية
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
    height: 1.6,
  );

  /// نصوص الأزرار
  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  /// عناوين الكروت
  static const TextStyle cardTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  /// نصوص داخل الكروت
  static const TextStyle cardBody = TextStyle(
    fontSize: 16,
    color: Colors.black87,
    height: 1.8,
  );
}
