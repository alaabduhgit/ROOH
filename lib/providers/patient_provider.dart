import 'package:flutter/material.dart';

import '../models/patient_model.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';
import '../services/patient_service.dart';

class PatientProvider with ChangeNotifier {
  final PatientService _patientService = PatientService();
  final LocalStorageService _localStorageService = LocalStorageService();
  final NotificationService _notificationService = NotificationService();

  PatientModel _currentPatient = PatientModel(
    id: '',
    name: '',
    bloodType: '',
    phone: '',
    totalRequests: 0,
  );

  bool _hasActiveRequest = false;
  bool _requestAccepted = false;
  bool _isLoading = false;

  String _activeRequestId = '';
  String _donorName = '';
  String _donorPhone = '';
  String? _errorMessage;

  PatientModel get currentPatient => _currentPatient;
  bool get hasActiveRequest => _hasActiveRequest;
  bool get requestAccepted => _requestAccepted;
  bool get isLoading => _isLoading;
  String get activeRequestId => _activeRequestId;
  String get donorName => _donorName;
  String get donorPhone => _donorPhone;
  String? get errorMessage => _errorMessage;

  bool get hasPatientSession {
    return _currentPatient.id.isNotEmpty;
  }

  Future<void> loadPatientById(String patientId) async {
    if (patientId.isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final document = await _patientService.getPatient(patientId);

      if (!document.exists || document.data() == null) {
        await _localStorageService.clearSession();

        _currentPatient = PatientModel(
          id: '',
          name: '',
          bloodType: '',
          phone: '',
          totalRequests: 0,
        );
      } else {
        _currentPatient = PatientModel.fromMap({
          ...document.data()!,
          'id': document.id,
        });
      }
    } catch (error) {
      _errorMessage = 'حدث خطأ أثناء تحميل بيانات المحتاج';
      debugPrint('Load patient error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createRequest({
    required String name,
    required String bloodType,
    required String phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final patientId = _patientService.generatePatientId();

      final patient = PatientModel(
        id: patientId,
        name: name,
        bloodType: bloodType,
        phone: phone,
        totalRequests: 0,
      );

      await _patientService.createPatient(id: patientId, data: patient.toMap());

      await _localStorageService.saveSession(
        userId: patientId,
        role: 'patient',
      );

      _currentPatient = patient;
    } catch (error) {
      _errorMessage = 'حدث خطأ أثناء تسجيل بيانات المحتاج';
      debugPrint('Create patient error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendRequestToDatabase({
    required String hospital,
    required String location,
    required String notes,
  }) async {
    if (_currentPatient.id.isEmpty) {
      _errorMessage = 'يجب تسجيل بيانات المحتاج أولاً';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final requestId = await _patientService.sendBloodRequest(
        requestData: {
          'patientId': _currentPatient.id,
          'patientName': _currentPatient.name,
          'patientPhone': _currentPatient.phone,
          'bloodType': _currentPatient.bloodType,
          'hospital': hospital,
          'location': location,
          'notes': notes,
        },
      );

      _activeRequestId = requestId;
      _hasActiveRequest = true;
      _requestAccepted = false;
      _donorName = '';
      _donorPhone = '';

      await _patientService.updatePatient(
        id: _currentPatient.id,
        data: {
          ..._currentPatient
              .copyWith(totalRequests: _currentPatient.totalRequests + 1)
              .toMap(),
        },
      );

      _currentPatient = _currentPatient.copyWith(
        totalRequests: _currentPatient.totalRequests + 1,
      );

      await _notificationService.notifyAvailableMatchingDonors(
        requestId: requestId,
        patientName: _currentPatient.name,
        bloodType: _currentPatient.bloodType,
        hospital: hospital,
      );
    } catch (error) {
      _errorMessage = 'حدث خطأ أثناء إرسال طلب التبرع';
      debugPrint('Send blood request error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelRequest() async {
    try {
      if (_activeRequestId.isNotEmpty) {
        await _patientService.deleteBloodRequest(_activeRequestId);
      }

      _activeRequestId = '';
      _hasActiveRequest = false;
      _requestAccepted = false;

      notifyListeners();
    } catch (error) {
      _errorMessage = 'حدث خطأ أثناء إلغاء الطلب';
      notifyListeners();
      debugPrint('Cancel request error: $error');
    }
  }

  void acceptRequest({required String donorName, required String donorPhone}) {
    _requestAccepted = true;
    _donorName = donorName;
    _donorPhone = donorPhone;
    notifyListeners();
  }

  Future<void> logoutAndDestroyAccount() async {
    try {
      if (_activeRequestId.isNotEmpty) {
        await _patientService.deleteBloodRequest(_activeRequestId);
      }

      if (_currentPatient.id.isNotEmpty) {
        await _patientService.deletePatientPendingRequests(_currentPatient.id);
        await _patientService.deletePatient(_currentPatient.id);
      }

      await _localStorageService.clearSession();

      _currentPatient = PatientModel(
        id: '',
        name: '',
        bloodType: '',
        phone: '',
        totalRequests: 0,
      );

      _hasActiveRequest = false;
      _requestAccepted = false;
      _isLoading = false;
      _activeRequestId = '';
      _donorName = '';
      _donorPhone = '';
      _errorMessage = null;

      notifyListeners();
    } catch (error) {
      _errorMessage = 'حدث خطأ أثناء حذف حساب المحتاج';
      notifyListeners();
      debugPrint('Delete patient account error: $error');
    }
  }
}
