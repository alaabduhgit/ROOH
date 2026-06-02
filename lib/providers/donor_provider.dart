import 'package:flutter/material.dart';

import '../models/donor_model.dart';
import '../services/donor_service.dart';

class DonorProvider with ChangeNotifier {
  final DonorService _donorService = DonorService();

  DonorModel _currentDonor = DonorModel(
    id: '101',
    name: 'أحمد محمد',
    bloodType: 'O+',
    isAvailable: false,
  );

  int _donationReadiness = 100;
  String _lastDonationDate = '20/9/2025';

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

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

  DonorModel get currentDonor => _currentDonor;
  int get donationReadiness => _donationReadiness;
  String get lastDonationDate => _lastDonationDate;

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String? get errorMessage => _errorMessage;

  List<Map<String, String>> get bloodRequests {
    if (_donationReadiness == 100 && _currentDonor.isAvailable) {
      return List.unmodifiable(_bloodRequests);
    }
    return [];
  }

  Future<void> registerDonor({
    required String name,
    required String phone,
    required String bloodType,
    required String city,
    required int age,
  }) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();

    try {
      final uid = _donorService.getCurrentUidOrTemporary();

      final donor = DonorModel(
        id: uid,
        name: name,
        phone: phone,
        bloodType: bloodType,
        city: city,
        age: age,
        isAvailable: false,
        donationReadiness: 100,
        lastDonationDate: null,
      );

      await _donorService.createDonor(donor);

      _currentDonor = donor;
      _donationReadiness = donor.donationReadiness;
      _lastDonationDate = 'لا يوجد';

      _isSuccess = true;
    } catch (error) {
      _errorMessage = 'حدث خطأ أثناء تسجيل المتبرع، حاول مرة أخرى';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleAvailability(bool value) async {
    if (_donationReadiness < 100) return;

    _currentDonor = DonorModel(
      id: _currentDonor.id,
      name: _currentDonor.name,
      phone: _currentDonor.phone,
      bloodType: _currentDonor.bloodType,
      city: _currentDonor.city,
      age: _currentDonor.age,
      isAvailable: value,
      donationReadiness: _currentDonor.donationReadiness,
      lastDonationDate: _currentDonor.lastDonationDate,
    );

    notifyListeners();

    // السطر الجديد للربط بالقاعدة:
    await _donorService.createDonor(_currentDonor);
  }

  Future<void> acceptBloodRequest(String requestId) async {
    try {
      _bloodRequests.removeWhere((request) => request['id'] == requestId);

      _donationReadiness = 0;

      _currentDonor = DonorModel(
        id: _currentDonor.id,
        name: _currentDonor.name,
        phone: _currentDonor.phone,
        bloodType: _currentDonor.bloodType,
        city: _currentDonor.city,
        age: _currentDonor.age,
        isAvailable: false,
        donationReadiness: 0,
        lastDonationDate: _currentDonor.lastDonationDate,
      );

      notifyListeners();
    } catch (e) {
      debugPrint("خطأ أثناء قبول الطلب: $e");
    }
  }

  void rejectBloodRequest(String requestId) {
    _bloodRequests.removeWhere((request) => request['id'] == requestId);
    notifyListeners();
  }

  Future<void> logoutAndDestroyAccount() async {
    try {
      _currentDonor = DonorModel(
        id: '',
        name: '',
        bloodType: '',
        isAvailable: false,
      );

      _isSuccess = false;
      _errorMessage = null;

      notifyListeners();
    } catch (error) {
      debugPrint('حدث خطأ أثناء حذف الحساب: $error');
    }
  }
}
