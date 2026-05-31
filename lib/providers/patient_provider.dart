import 'package:flutter/material.dart';
import '../models/patient_model.dart';

class PatientProvider with ChangeNotifier {
  PatientModel _currentPatient = PatientModel(
    id: '201',
    name: 'آلاء عبده',
    bloodType: 'O+',
    phone: '777777777',
    totalRequests: 3,
  );

  bool _hasActiveRequest = false;
  bool _requestAccepted = false;

  String _donorName = '';
  String _donorPhone = '';

  PatientModel get currentPatient => _currentPatient;
  bool get hasActiveRequest => _hasActiveRequest;
  bool get requestAccepted => _requestAccepted;
  String get donorName => _donorName;
  String get donorPhone => _donorPhone;

  void createRequest() {
    _hasActiveRequest = true;
    notifyListeners();
  }

  void cancelRequest() {
    _hasActiveRequest = false;
    notifyListeners();
  }

  void acceptRequest({
    required String donorName,
    required String donorPhone,
  }) {
    _requestAccepted = true;
    _donorName = donorName;
    _donorPhone = donorPhone;
    notifyListeners();
  }

  Future<void> logoutAndDestroyAccount() async {
    try {
      _currentPatient = PatientModel(
        id: '',
        name: '',
        bloodType: '',
        phone: '',
        totalRequests: 0,
      );

      _hasActiveRequest = false;
      _requestAccepted = false;
      _donorName = '';
      _donorPhone = '';

      notifyListeners();
    } catch (error) {
      debugPrint('حدث خطأ أثناء حذف الحساب: $error');
    }
  }
}