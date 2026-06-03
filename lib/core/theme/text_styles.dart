import 'package:flutter/material.dart';

import 'light_theme.dart';

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    fontFamily: 'Cairo',
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
    height: 1.6,
    fontFamily: 'Cairo',
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: 'Cairo',
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    fontFamily: 'Cairo',
  );

  static const TextStyle cardBody = TextStyle(
    fontSize: 16,
    color: Colors.black87,
    height: 1.8,
    fontFamily: 'Cairo',
  );
}
