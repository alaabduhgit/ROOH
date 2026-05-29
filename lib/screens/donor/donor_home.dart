import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';
import '../../providers/donor_provider.dart';
import 'control_donor.dart';
import 'request_donor.dart';
import 'widgets/donor_widgets.dart';

class HomeDonorScreen extends StatelessWidget {
  const HomeDonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: const Drawer(),
        extendBody: true,
        body: AppBackground(
          child: SafeArea(
            child: Consumer<DonorProvider>(
              builder: (context, provider, child) {
                final donor = provider.currentDonor;
                final readiness = provider.donationReadiness;
                final requests = provider.bloodRequests;

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          return Container(
                            child: Text(
                              'لوحة المتبرع',
                              style: AppTextStyles.title,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 28),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(.06),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'شكراً لك، عملك النبيل ينقذ الأرواح!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'لقد استعدت $readiness% من قدرتك على التبرع',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    provider.lastDonationDate,
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Switch(
                                        onChanged: readiness == 100
                                            ? provider.toggleAvailability
                                            : null,
                                        value: readiness == 100
                                            ? donor.isAvailable
                                            : false,
                                        activeColor: AppColors.primary,
                                      ),
                                      Text(
                                        readiness == 100 && donor.isAvailable
                                            ? 'متاح'
                                            : 'غير متاح',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              readiness == 100 &&
                                                  donor.isAvailable
                                              ? Colors.green
                                              : AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 78,
                                  height: 78,
                                  child: CircularProgressIndicator(
                                    value: readiness / 100,
                                    strokeWidth: 9,
                                    backgroundColor: AppColors.grey.withOpacity(
                                      .25,
                                    ),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      readiness == 100
                                          ? Colors.green
                                          : AppColors.primary,
                                    ),
                                  ),
                                ),
                                Text(
                                  '%$readiness',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'طلبات التبرع المستلمة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          fontFamily: 'Cairo',
                        ),
                      ),

                      const SizedBox(height: 10),

                      Expanded(
                        child: requests.isEmpty
                            ? Center(
                                child: Text(
                                  readiness < 100
                                      ? 'لن تظهر الطلبات حتى تكتمل جاهزيتك 100%'
                                      : 'لا توجد طلبات تبرع حالياً أو حالتك غير متاح',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.grey),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 95),
                                physics: const BouncingScrollPhysics(),
                                itemCount: requests.length,
                                itemBuilder: (context, index) {
                                  final item = requests[index];

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.card,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                      leading: CircleAvatar(
                                        backgroundColor: AppColors.primary,
                                        child: Text(
                                          item['bloodType'] ?? '',
                                          style: const TextStyle(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        item['title'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => RequestDonorScreen(
                                              requestDetails: item,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: const DonorBottomNav(currentIndex: 2),
      ),
    );
  }
}
