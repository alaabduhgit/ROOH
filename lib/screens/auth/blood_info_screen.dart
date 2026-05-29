import 'dart:ui';
import 'package:flutter/material.dart';

import '/core/theme/light_theme.dart';
import '/core/widgets/widget.dart';

class BloodInfoScreen extends StatefulWidget {
  const BloodInfoScreen({super.key});

  @override
  State<BloodInfoScreen> createState() => _BloodInfoScreenState();
}

class _BloodInfoScreenState extends State<BloodInfoScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollHint = true;

  Widget infoCard(String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.primary, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bloodTable() {
    Widget bloodCard({
      required String type,
      required String give,
      required String take,
      required bool isPositive,
    }) {
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isPositive ? Colors.redAccent : Colors.blueAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "تعطي لـ:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(give),
                  const SizedBox(height: 8),
                  const Text(
                    "تأخذ من:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(take),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              const Text(
                "فصائل الدم",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 15),

              bloodCard(
                type: "O-",
                give: "الجميع",
                take: "O- فقط",
                isPositive: false,
              ),

              bloodCard(
                type: "O+",
                give: "O+, A+, B+, AB+",
                take: "O+, O-",
                isPositive: true,
              ),

              bloodCard(
                type: "A+",
                give: "A+, AB+",
                take: "A+, A-, O+, O-",
                isPositive: true,
              ),

              bloodCard(
                type: "A-",
                give: "A+, A-, AB+, AB-",
                take: "A-, O-",
                isPositive: false,
              ),

              bloodCard(
                type: "B+",
                give: "B+, AB+",
                take: "B+, B-, O+, O-",
                isPositive: true,
              ),

              bloodCard(
                type: "B-",
                give: "B+, B-, AB+, AB-",
                take: "B-, O-",
                isPositive: false,
              ),

              bloodCard(
                type: "AB+",
                give: "AB+ فقط",
                take: "الجميع",
                isPositive: true,
              ),

              bloodCard(
                type: "AB-",
                give: "AB+, AB-",
                take: "A-, B-, AB-, O-",
                isPositive: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && _showScrollHint) {
        setState(() {
          _showScrollHint = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  appBackButton(context),

                  const SizedBox(height: 20),

                  const Text(
                    "التثقيف الصحي",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 30),

                  infoCard(
                    "فوائد التبرع بالدم",
                    "• إنقاذ حياة المرضى\n"
                        "• تنشيط الدورة الدموية\n"
                        "• تجديد خلايا الدم\n"
                        "• تقليل نسبة الحديد الضار\n"
                        "• تعزيز صحة القلب",
                    Icons.volunteer_activism,
                  ),

                  infoCard(
                    "شروط التبرع",
                    "• العمر من 18 إلى 65 سنة\n"
                        "• الوزن فوق 50 كجم\n"
                        "• صحة جيدة\n"
                        "• عدم وجود أمراض معدية\n"
                        "• مرور فترة كافية منذ آخر تبرع",
                    Icons.check_circle,
                  ),

                  infoCard(
                    "متى يمنع التبرع؟",
                    "• وجود حرارة أو مرض\n"
                        "• انخفاض الهيموجلوبين\n"
                        "• الحمل\n"
                        "• العمليات الحديثة\n"
                        "• بعض الأمراض المزمنة",
                    Icons.cancel,
                  ),

                  infoCard(
                    "نصائح قبل التبرع",
                    "• شرب الماء بكثرة\n"
                        "• تناول وجبة خفيفة\n"
                        "• النوم الجيد\n"
                        "• تجنب التدخين قبل التبرع",
                    Icons.lightbulb,
                  ),

                  infoCard(
                    "نصائح بعد التبرع",
                    "• الراحة لمدة 10 دقائق\n"
                        "• شرب العصائر والماء\n"
                        "• تجنب حمل الأشياء الثقيلة\n"
                        "• تناول أطعمة غنية بالحديد",
                    Icons.favorite,
                  ),

                  const SizedBox(height: 20),

                  bloodTable(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          /// سهم التمرير
          if (_showScrollHint)
            const Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Icon(
                Icons.keyboard_double_arrow_down,
                size: 45,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}
