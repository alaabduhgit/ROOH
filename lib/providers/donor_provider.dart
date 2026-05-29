// donor_provider.dart
import 'package:flutter/material.dart';
import '../models/donor_model.dart';

class DonorProvider with ChangeNotifier {
  Donor_model _currentDonor = Donor_model(
    id: '101',
    name: 'أحمد محمد',
    bloodType: 'O+',
    isAvailable: false,
  );

  int _donationReadiness = 100;
  String _lastDonationDate = '20/9/2025';

  final List<Map<String, String>> _bloodRequests = [
    {
      'id': '1',
      'title': 'طلب تبرع عاجل - مستشفى الثورة',
      'hospital': 'مستشفى الثورة العام',
      'bloodType': 'O+',
    },
    {
      'id': '2',
      'title': 'طلب تبرع - مستشفى اليمن الدولي',
      'hospital': 'مستشفى اليمن الدولي',
      'bloodType': 'O+',
    },
  ];

  Donor_model get currentDonor => _currentDonor;
  int get donationReadiness => _donationReadiness;
  String get lastDonationDate => _lastDonationDate;

  List<Map<String, String>> get bloodRequests {
    if (_donationReadiness == 100 && _currentDonor.isAvailable) {
      return List.unmodifiable(_bloodRequests);
    }
    return [];
  }

  void toggleAvailability(bool value) {
    if (_donationReadiness < 100) return;

    _currentDonor = Donor_model(
      id: _currentDonor.id,
      name: _currentDonor.name,
      bloodType: _currentDonor.bloodType,
      isAvailable: value,
    );

    notifyListeners();
  }

  // تم تصحيح الدالة وتفعيلها هنا لتلافي التكرار والخطأ البرمجي
  Future<void> acceptBloodRequest(String requestId) async {
    try {
      // 1. كود قَبول الطلب في الـ Firebase أو العمليات البرمجية المحلية الخاصة بكِ
      // يمكنكِ تفعيل الكود أدناه لاحقاً لإزالة الطلب المقبول من القائمة كي لا يظهر مجدداً
      _bloodRequests.removeWhere((request) => request['id'] == requestId);

      // 2. التحديث التلقائي للحالة ونسبة الجاهزية بعد الموافقة
      _donationReadiness =
          0; // تقليل النسبة إلى 0% لأن المستخدم وافق على التبرع الآن

      // الحل الصحيح: إعادة بناء كائن المتبرع وتمرير قيمة false للـ isAvailable
      _currentDonor = Donor_model(
        id: _currentDonor.id,
        name: _currentDonor.name,
        bloodType: _currentDonor.bloodType,
        isAvailable: false, // تحويل السويتش تلقائياً لغير متاح
      );

      // 3. تحديث قاعدة البيانات الفايربيس بالحالة الجديدة للمتبرع (اختياري حسب مشروعك)
      // await _db.collection('donors').doc(_currentDonor.id).update({
      //   'isAvailable': false,
      //   'donationReadiness': 0,
      // });

      // 4. إعلام جميع الشاشات بالتغيير لتحديث الواجهات فوراً
      notifyListeners();
    } catch (e) {
      print("خطأ أثناء قبول الطلب: $e");
    }
  }

  void rejectBloodRequest(String requestId) {
    _bloodRequests.removeWhere((request) => request['id'] == requestId);
    notifyListeners();
  }

  Future<void> logoutAndDestroyAccount() async {
    try {
      _currentDonor = Donor_model(
        id: '',
        name: '',
        bloodType: '',
        isAvailable: false,
      );
      notifyListeners();
    } catch (error) {
      debugPrint('حدث خطأ أثناء حذف الحساب: $error');
    }
  }
}
