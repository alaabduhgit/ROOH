import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/donor_model.dart';

class DonorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _donorsCollection {
    return _firestore.collection('donors');
  }

  String getCurrentUidOrTemporary() {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      return currentUser.uid;
    }

    return 'donor_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> createDonor(DonorModel donor) async {
    await _donorsCollection.doc(donor.id).set({
      ...donor.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateDonor(DonorModel donor) async {
    if (donor.id.isEmpty) return;

    await _donorsCollection.doc(donor.id).set({
      ...donor.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<DonorModel?> getDonor(String donorId) async {
    if (donorId.isEmpty) return null;

    final document = await _donorsCollection.doc(donorId).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return DonorModel.fromMap({...document.data()!, 'id': document.id});
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchDonor(String donorId) {
    return _donorsCollection.doc(donorId).snapshots();
  }

  Future<void> updateAvailability({
    required String donorId,
    required bool isAvailable,
  }) async {
    if (donorId.isEmpty) return;

    await _donorsCollection.doc(donorId).set({
      'isAvailable': isAvailable,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> markDonorAfterAcceptedRequest({required String donorId}) async {
    if (donorId.isEmpty) return;

    await _donorsCollection.doc(donorId).set({
      'isAvailable': false,
      'donationReadiness': 0,
      'lastDonationDate': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteDonor(String donorId) async {
    if (donorId.isEmpty) return;

    await _donorsCollection.doc(donorId).delete();
  }
}
