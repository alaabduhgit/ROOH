// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'patient_service.dart';

// class NeedService {
//   final PatientService _patientService = PatientService();

//   Future<String> sendNeedRequest(Map<String, dynamic> requestData) {
//     return _patientService.sendBloodRequest(requestData: requestData);
//   }

//   Stream<QuerySnapshot<Map<String, dynamic>>> getPendingNeedRequests() {
//     return _patientService.getPendingRequests();
//   }

//   Future<void> deleteNeedRequest(String requestId) {
//     return _patientService.deleteBloodRequest(requestId);
//   }
// }
