import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/donor_model.dart';

class DonorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getCurrentUidOrTemporary() {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      return currentUser.uid;
    }

    return 'temp_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> createDonor(DonorModel donor) async {
    await _firestore.collection('donors').doc(donor.id).set(donor.toMap());
  }

  // دالة جديدة لجلب بيانات متبرع معين من السحاب بواسطة الـ ID
  Future<DonorModel?> getDonor(String id) async {
    final doc = await _firestore.collection('donors').doc(id).get();
    if (doc.exists && doc.data() != null) {
      return DonorModel.fromMap(doc.data()!);
    }
    return null;
  }
}
