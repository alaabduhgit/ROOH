import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notificationsCollection {
    return _firestore.collection('notifications');
  }

  CollectionReference<Map<String, dynamic>> get _donorsCollection {
    return _firestore.collection('donors');
  }

  Future<void> notifyAvailableMatchingDonors({
    required String requestId,
    required String patientName,
    required String bloodType,
    required String hospital,
  }) async {
    if (requestId.isEmpty || bloodType.isEmpty) return;

    final donorsSnapshot = await _donorsCollection
        .where('bloodType', isEqualTo: bloodType)
        .where('isAvailable', isEqualTo: true)
        .get();

    if (donorsSnapshot.docs.isEmpty) return;

    final batch = _firestore.batch();

    for (final donorDocument in donorsSnapshot.docs) {
      final notificationDocument = _notificationsCollection.doc();

      batch.set(notificationDocument, {
        'id': notificationDocument.id,
        'receiverId': donorDocument.id,
        'receiverRole': 'donor',
        'requestId': requestId,
        'title': 'طلب تبرع جديد',
        'body': 'يوجد طلب تبرع لفصيلة $bloodType في $hospital',
        'patientName': patientName,
        'bloodType': bloodType,
        'hospital': hospital,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchDonorNotifications(
    String donorId,
  ) {
    return _notificationsCollection
        .where('receiverId', isEqualTo: donorId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    if (notificationId.isEmpty) return;

    await _notificationsCollection.doc(notificationId).set({
      'isRead': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteNotificationsForUser(String userId) async {
    if (userId.isEmpty) return;

    final snapshot = await _notificationsCollection
        .where('receiverId', isEqualTo: userId)
        .get();

    final batch = _firestore.batch();

    for (final document in snapshot.docs) {
      batch.delete(document.reference);
    }

    await batch.commit();
  }
}
