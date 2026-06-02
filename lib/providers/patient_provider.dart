import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../services/patient_service.dart'; // سطر الاستدعاء الخارجي

class PatientProvider with ChangeNotifier {
  final PatientService _patientService = PatientService();

  // تركنا الكائن هنا كما هو بالقيم الافتراضية الأولى
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

  Future<void> createRequest({
    required String name,
    required String bloodType,
    required String phone,
  }) async {
    _hasActiveRequest = true;

    // ✨ التعديل السحري هنا: تحديث كائن المريض بالاسم والبيانات الجديدة المكتوبة فوراً
    _currentPatient = PatientModel(
      id: _currentPatient.id, // الحفاظ على نفس المعرف الحالي
      name: name, // هنا سيتم تخزين أي اسم جديد تكتبينه في الحقل
      bloodType: bloodType,
      phone: phone,
      totalRequests: _currentPatient.totalRequests,
    );

    notifyListeners();

    // إرسال البيانات الفعلية لجدول patients في الفايربيس
    await _patientService.addPatient({
      'name': name,
      'bloodType': bloodType,
      'phone': phone,
      'totalRequests': 1,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  // دالة إرسال الطلب للسيرفر
  Future<void> sendRequestToDatabase({
    required String hospital,
    required String location,
    required String notes,
  }) async {
    try {
      await _patientService.sendBloodRequest({
        'patientName': _currentPatient.name,
        'patientPhone': _currentPatient.phone,
        'bloodType': _currentPatient.bloodType,
        'hospital': hospital,
        'location': location,
        'notes': notes,
      });

      // بمجرد نجاح الإرسال، نغير الحالة
      _hasActiveRequest = true;
      notifyListeners();
    } catch (e) {
      debugPrint("خطأ في إرسال الطلب: $e");
    }
  }

  // تحويل الدالة إلى دالة سحابية (async) لتقوم بالحذف الفعلي
  Future<void> cancelRequest() async {
    _hasActiveRequest = false;
    notifyListeners();

    try {
      // حذف الطلب حقيقياً من جدول patients في الفايربيس باستخدام الـ ID
      await _patientService.deletePatientRequest(_currentPatient.id);
    } catch (error) {
      debugPrint('حدث خطأ أثناء إلغاء الطلب من السحاب: $error');
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
