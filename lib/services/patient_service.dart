import 'package:cloud_firestore/cloud_firestore.dart';

class PatientService {
  // قمنا بتغيير اسم الكلاس ليطابق اسم الملف
  // تحديد المرجع للـ Collection الخاص بالمرضى/المحتاجين
  final CollectionReference _patientsCollection = FirebaseFirestore.instance
      .collection('patients'); // غيرنا اسم المجموعة لتكون patients

  // دالة إضافة مريض (محتاج)
  Future<void> addPatient(Map<String, dynamic> patientData) async {
    try {
      await _patientsCollection.add(patientData);
    } catch (e) {
      print("Error adding patient: $e");
      rethrow;
    }
  }

  // دالة جلب بيانات المرضى
  Stream<QuerySnapshot> getPatients() {
    return _patientsCollection.snapshots();
  }

  // دالة جديدة لحذف طلب المريض من السحاب عند الاكتفاء
  Future<void> deletePatientRequest(String patientId) async {
    try {
      await _patientsCollection.doc(patientId).delete();
    } catch (e) {
      print("Error deleting patient request: $e");
      rethrow;
    }
  }

  // دالة إرسال طلب تبرع جديد
  Future<void> sendBloodRequest(Map<String, dynamic> requestData) async {
    try {
      await FirebaseFirestore.instance.collection('requests').add({
        ...requestData,
        'status': 'pending', // حالة الطلب عند الإرسال
        'createdAt': FieldValue.serverTimestamp(), // وقت إرسال الطلب
      });
    } catch (e) {
      print("Error sending blood request: $e");
      rethrow;
    }
  }
}
