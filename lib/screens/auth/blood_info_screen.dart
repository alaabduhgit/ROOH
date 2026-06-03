import 'package:flutter/material.dart';

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';

class BloodInfoScreen extends StatefulWidget {
  const BloodInfoScreen({super.key});

  @override
  State<BloodInfoScreen> createState() => _BloodInfoScreenState();
}

class _BloodInfoScreenState extends State<BloodInfoScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollHint = true;

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

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      child: AppGlassContainer(
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
      ),
    );
  }

  Widget _buildBloodCard({
    required String type,
    required String give,
    required String take,
    required bool isPositive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white.withOpacity(0.3)),
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
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
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
                  'تعطي لـ:',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  give,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'تأخذ من:',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  take,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodTable() {
    return AppGlassContainer(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          const Text(
            'فصائل الدم',
            textAlign: TextAlign.center,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 15),
          _buildBloodCard(
            type: 'O-',
            give: 'الجميع',
            take: 'O- فقط',
            isPositive: false,
          ),
          _buildBloodCard(
            type: 'O+',
            give: 'O+, A+, B+, AB+',
            take: 'O+, O-',
            isPositive: true,
          ),
          _buildBloodCard(
            type: 'A+',
            give: 'A+, AB+',
            take: 'A+, A-, O+, O-',
            isPositive: true,
          ),
          _buildBloodCard(
            type: 'A-',
            give: 'A+, A-, AB+, AB-',
            take: 'A-, O-',
            isPositive: false,
          ),
          _buildBloodCard(
            type: 'B+',
            give: 'B+, AB+',
            take: 'B+, B-, O+, O-',
            isPositive: true,
          ),
          _buildBloodCard(
            type: 'B-',
            give: 'B+, B-, AB+, AB-',
            take: 'B-, O-',
            isPositive: false,
          ),
          _buildBloodCard(
            type: 'AB+',
            give: 'AB+ فقط',
            take: 'الجميع',
            isPositive: true,
          ),
          _buildBloodCard(
            type: 'AB-',
            give: 'AB+, AB-',
            take: 'A-, B-, AB-, O-',
            isPositive: false,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: AppBackground(
          child: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      appBackButton(context),

                      const SizedBox(height: 20),

                      const Text(
                        'التثقيف الصحي',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.title,
                      ),

                      const SizedBox(height: 30),

                      _buildInfoCard(
                        title: 'فوائد التبرع بالدم',
                        content:
                            '• إنقاذ حياة المرضى\n'
                            '• تنشيط الدورة الدموية\n'
                            '• تجديد خلايا الدم\n'
                            '• تقليل نسبة الحديد الضار\n'
                            '• تعزيز صحة القلب',
                        icon: Icons.volunteer_activism,
                      ),

                      _buildInfoCard(
                        title: 'شروط التبرع',
                        content:
                            '• العمر من 18 إلى 65 سنة\n'
                            '• الوزن فوق 50 كجم\n'
                            '• صحة جيدة\n'
                            '• عدم وجود أمراض معدية\n'
                            '• مرور فترة كافية منذ آخر تبرع',
                        icon: Icons.check_circle,
                      ),

                      _buildInfoCard(
                        title: 'متى يمنع التبرع؟',
                        content:
                            '• وجود حرارة أو مرض\n'
                            '• انخفاض الهيموجلوبين\n'
                            '• الحمل\n'
                            '• العمليات الحديثة\n'
                            '• بعض الأمراض المزمنة',
                        icon: Icons.cancel,
                      ),

                      _buildInfoCard(
                        title: 'نصائح قبل التبرع',
                        content:
                            '• شرب الماء بكثرة\n'
                            '• تناول وجبة خفيفة\n'
                            '• النوم الجيد\n'
                            '• تجنب التدخين قبل التبرع',
                        icon: Icons.lightbulb,
                      ),

                      _buildInfoCard(
                        title: 'نصائح بعد التبرع',
                        content:
                            '• الراحة لمدة 10 دقائق\n'
                            '• شرب العصائر والماء\n'
                            '• تجنب حمل الأشياء الثقيلة\n'
                            '• تناول أطعمة غنية بالحديد',
                        icon: Icons.favorite,
                      ),

                      const SizedBox(height: 20),

                      _buildBloodTable(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              if (_showScrollHint)
                const Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Icon(
                    Icons.keyboard_double_arrow_down,
                    size: 45,
                    color: AppColors.black,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
