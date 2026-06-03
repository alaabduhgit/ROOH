import 'package:cloud_firestore/cloud_firestore.dart';

class PatientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _patientsCollection {
    return _firestore.collection('patients');
  }

  CollectionReference<Map<String, dynamic>> get _requestsCollection {
    return _firestore.collection('requests');
  }

  String generatePatientId() {
    return 'patient_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> createPatient({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await _patientsCollection.doc(id).set({
      ...data,
      'id': id,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updatePatient({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await _patientsCollection.doc(id).set({
      ...data,
      'id': id,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPatient(String patientId) {
    return _patientsCollection.doc(patientId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchPatient(
    String patientId,
  ) {
    return _patientsCollection.doc(patientId).snapshots();
  }

  Future<void> deletePatient(String patientId) async {
    if (patientId.isEmpty) return;
    await _patientsCollection.doc(patientId).delete();
  }

  Future<String> sendBloodRequest({
    required Map<String, dynamic> requestData,
  }) async {
    final requestDocument = await _requestsCollection.add({
      ...requestData,
      'status': 'pending',
      'acceptedByDonorId': null,
      'acceptedByDonorName': null,
      'acceptedByDonorPhone': null,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return requestDocument.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPendingRequests() {
    return _requestsCollection
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPatientRequests(
    String patientId,
  ) {
    return _requestsCollection
        .where('patientId', isEqualTo: patientId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> acceptBloodRequest({
    required String requestId,
    required String donorId,
    required String donorName,
    required String donorPhone,
  }) async {
    if (requestId.isEmpty) return;

    await _requestsCollection.doc(requestId).set({
      'status': 'accepted',
      'acceptedByDonorId': donorId,
      'acceptedByDonorName': donorName,
      'acceptedByDonorPhone': donorPhone,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> rejectBloodRequest({
    required String requestId,
    required String donorId,
  }) async {
    if (requestId.isEmpty || donorId.isEmpty) return;

    await _requestsCollection.doc(requestId).set({
      'rejectedByDonors': FieldValue.arrayUnion([donorId]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteBloodRequest(String requestId) async {
    if (requestId.isEmpty) return;
    await _requestsCollection.doc(requestId).delete();
  }

  Future<void> deletePatientPendingRequests(String patientId) async {
    if (patientId.isEmpty) return;

    final snapshot = await _requestsCollection
        .where('patientId', isEqualTo: patientId)
        .where('status', isEqualTo: 'pending')
        .get();

    final batch = _firestore.batch();

    for (final document in snapshot.docs) {
      batch.delete(document.reference);
    }

    await batch.commit();
  }
}
