import 'package:flutter/material.dart';

import '../models/donor_model.dart';
import '../services/donor_service.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';
import '../services/patient_service.dart';

class DonorProvider with ChangeNotifier {
  final DonorService _donorService = DonorService();
  final PatientService _patientService = PatientService();
  final LocalStorageService _localStorageService = LocalStorageService();
  final NotificationService _notificationService = NotificationService();

  DonorModel _currentDonor = DonorModel(
    id: '',
    name: '',
    bloodType: '',
    isAvailable: false,
  );

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

  DonorModel get currentDonor => _currentDonor;
  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String? get errorMessage => _errorMessage;

  int get donationReadiness => _currentDonor.donationReadiness;

  String get lastDonationDate {
    final date = _currentDonor.lastDonationDate;

    if (date == null) {
      return 'لا يوجد تبرع سابق';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  bool get hasDonorSession {
    return _currentDonor.id.isNotEmpty;
  }

  Future<void> loadDonorById(String donorId) async {
    if (donorId.isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final donor = await _donorService.getDonor(donorId);

      if (donor == null) {
        await _localStorageService.clearSession();
        _currentDonor = DonorModel(
          id: '',
          name: '',
          bloodType: '',
          isAvailable: false,
        );
      } else {
        _currentDonor = donor;
      }
    } catch (error) {
      _errorMessage = 'حدث خطأ أثناء تحميل بيانات المتبرع';
      debugPrint('Load donor error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
      final donorId = _donorService.getCurrentUidOrTemporary();

      final donor = DonorModel(
        id: donorId,
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

      await _localStorageService.saveSession(userId: donorId, role: 'donor');

      _currentDonor = donor;
      _isSuccess = true;
    } catch (error) {
      _errorMessage = 'حدث خطأ أثناء تسجيل المتبرع، حاول مرة أخرى';
      debugPrint('Register donor error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleAvailability(bool value) async {
    if (_currentDonor.id.isEmpty) return;
    if (_currentDonor.donationReadiness < 100) return;

    final previousDonor = _currentDonor;

    _currentDonor = _currentDonor.copyWith(isAvailable: value);
    notifyListeners();

    try {
      await _donorService.updateAvailability(
        donorId: _currentDonor.id,
        isAvailable: value,
      );
    } catch (error) {
      _currentDonor = previousDonor;
      notifyListeners();
      debugPrint('Update donor availability error: $error');
    }
  }

  Future<void> acceptBloodRequest(String requestId) async {
    if (requestId.isEmpty || _currentDonor.id.isEmpty) return;

    try {
      await _patientService.acceptBloodRequest(
        requestId: requestId,
        donorId: _currentDonor.id,
        donorName: _currentDonor.name,
        donorPhone: _currentDonor.phone,
      );

      await _donorService.markDonorAfterAcceptedRequest(
        donorId: _currentDonor.id,
      );

      _currentDonor = _currentDonor.copyWith(
        isAvailable: false,
        donationReadiness: 0,
        lastDonationDate: DateTime.now(),
      );

      notifyListeners();
    } catch (error) {
      _errorMessage = 'حدث خطأ أثناء قبول الطلب';
      notifyListeners();
      debugPrint('Accept blood request error: $error');
    }
  }

  Future<void> rejectBloodRequest(String requestId) async {
    if (requestId.isEmpty || _currentDonor.id.isEmpty) return;

    try {
      await _patientService.rejectBloodRequest(
        requestId: requestId,
        donorId: _currentDonor.id,
      );
    } catch (error) {
      debugPrint('Reject blood request error: $error');
    }
  }

  Future<void> logoutAndDestroyAccount() async {
    try {
      final donorId = _currentDonor.id;

      if (donorId.isNotEmpty) {
        await _notificationService.deleteNotificationsForUser(donorId);
        await _donorService.deleteDonor(donorId);
      }

      await _localStorageService.clearSession();

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
      _errorMessage = 'حدث خطأ أثناء حذف حساب المتبرع';
      notifyListeners();
      debugPrint('Delete donor account error: $error');
    }
  }
}
