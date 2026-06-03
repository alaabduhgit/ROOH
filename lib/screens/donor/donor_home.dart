import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/core/theme/light_theme.dart';
import '/core/theme/text_styles.dart';
import '/core/widgets/widget.dart';
import '../../providers/donor_provider.dart';
import '../../services/patient_service.dart';
import 'request_donor.dart';
import 'widgets/donor_widgets.dart';

class HomeDonorScreen extends StatelessWidget {
  const HomeDonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientService = PatientService();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: const Drawer(),
        extendBody: true,
        body: AppBackground(
          child: SafeArea(
            child: Consumer<DonorProvider>(
              builder: (context, donorProvider, child) {
                final donor = donorProvider.currentDonor;
                final readiness = donorProvider.donationReadiness;

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (drawerContext) {
                          return Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(.90),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                'لوحة المتبرع',
                                style: AppTextStyles.title,
                              ),
                              const Spacer(),
                              const SizedBox(width: 48),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 28),

                      _buildHeaderCard(
                        readiness: readiness,
                        lastDonationDate: donorProvider.lastDonationDate,
                        isAvailable: donor.isAvailable,
                        onAvailabilityChanged: readiness == 100
                            ? donorProvider.toggleAvailability
                            : null,
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
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: patientService.getPendingRequests(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                  'حدث خطأ أثناء تحميل الطلبات',
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }

                            final requests =
                                snapshot.data?.docs.where((doc) {
                                  final data = doc.data();

                                  final bloodTypeMatches =
                                      data['bloodType'] == donor.bloodType;

                                  final rejectedBy = data['rejectedByDonors'];

                                  final isRejectedByCurrentDonor =
                                      rejectedBy is List &&
                                      rejectedBy.contains(donor.id);

                                  return donor.isAvailable &&
                                      readiness == 100 &&
                                      bloodTypeMatches &&
                                      !isRejectedByCurrentDonor;
                                }).toList() ??
                                [];

                            if (!donor.isAvailable || readiness < 100) {
                              return Center(
                                child: Text(
                                  readiness < 100
                                      ? 'لن تظهر الطلبات حتى تكتمل جاهزيتك 100%'
                                      : 'لا توجد طلبات تبرع حالياً أو حالتك غير متاح',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.grey),
                                ),
                              );
                            }

                            if (requests.isEmpty) {
                              return Center(
                                child: Text(
                                  'لا توجد طلبات مطابقة لفصيلة دمك حالياً',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.grey),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.only(bottom: 95),
                              physics: const BouncingScrollPhysics(),
                              itemCount: requests.length,
                              itemBuilder: (context, index) {
                                final document = requests[index];
                                final data = {
                                  ...document.data(),
                                  'id': document.id,
                                };

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: AppColors.primary,
                                      child: Text(
                                        data['bloodType']?.toString() ?? '',
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      data['patientName']?.toString() ??
                                          'مريض بحاجة للتبرع',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                    subtitle: Text(
                                      data['hospital']?.toString() ??
                                          'المستشفى غير محدد',
                                      style: TextStyle(
                                        color: AppColors.grey,
                                        fontFamily: 'Cairo',
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
                                            requestDetails: data,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
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

  Widget _buildHeaderCard({
    required int readiness,
    required String lastDonationDate,
    required bool isAvailable,
    required ValueChanged<bool>? onAvailabilityChanged,
  }) {
    return Container(
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
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  lastDonationDate,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Switch(
                      onChanged: onAvailabilityChanged,
                      value: readiness == 100 ? isAvailable : false,
                      activeColor: AppColors.primary,
                    ),
                    Text(
                      readiness == 100 && isAvailable ? 'متاح' : 'غير متاح',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: readiness == 100 && isAvailable
                            ? Colors.green
                            : AppColors.primary,
                        fontFamily: 'Cairo',
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
                  backgroundColor: AppColors.grey.withOpacity(.25),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    readiness == 100 ? Colors.green : AppColors.primary,
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
    );
  }
}
