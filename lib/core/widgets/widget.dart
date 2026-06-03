import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/light_theme.dart';
import '../theme/text_styles.dart';

InputDecoration appInputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: AppColors.primary),
    filled: true,
    fillColor: AppColors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
  );
}

ButtonStyle appButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    disabledBackgroundColor: AppColors.primary.withOpacity(.45),
    disabledForegroundColor: AppColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  );
}

Widget appBackButton(BuildContext context) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(.90),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
      ),
    ),
  );
}

Widget appForwardButton({required VoidCallback onPressed}) {
  return Container(
    width: 75,
    height: 75,
    decoration: BoxDecoration(
      color: AppColors.primary.withOpacity(0.45),
      shape: BoxShape.circle,
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.white,
        size: 34,
      ),
    ),
  );
}

class AppBackground extends StatelessWidget {
  final Widget child;
  final String imagePath;
  final Color overlayColor;

  const AppBackground({
    super.key,
    required this.child,
    this.imagePath = 'assets/bg.png',
    this.overlayColor = const Color(0x14FFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: overlayColor)),
        child,
      ],
    );
  }
}

class AppGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? color;

  const AppGlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 25,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? AppColors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColors.white.withOpacity(0.3)),
          ),
          child: child,
        ),
      ),
    );
  }
}

Widget infoCard({
  required String title,
  required String content,
  required IconData icon,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: AppTextStyles.cardTitle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          textAlign: TextAlign.right,
          style: AppTextStyles.cardBody,
        ),
      ],
    ),
  );
}
