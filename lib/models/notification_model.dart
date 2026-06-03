import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String receiverId;
  final String receiverRole;
  final String requestId;
  final String title;
  final String body;
  final String patientName;
  final String bloodType;
  final String hospital;
  final bool isRead;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.receiverId,
    required this.receiverRole,
    required this.requestId,
    required this.title,
    required this.body,
    required this.patientName,
    required this.bloodType,
    required this.hospital,
    this.isRead = false,
    this.createdAt,
  });

  NotificationModel copyWith({
    String? id,
    String? receiverId,
    String? receiverRole,
    String? requestId,
    String? title,
    String? body,
    String? patientName,
    String? bloodType,
    String? hospital,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      receiverId: receiverId ?? this.receiverId,
      receiverRole: receiverRole ?? this.receiverRole,
      requestId: requestId ?? this.requestId,
      title: title ?? this.title,
      body: body ?? this.body,
      patientName: patientName ?? this.patientName,
      bloodType: bloodType ?? this.bloodType,
      hospital: hospital ?? this.hospital,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receiverId': receiverId,
      'receiverRole': receiverRole,
      'requestId': requestId,
      'title': title,
      'body': body,
      'patientName': patientName,
      'bloodType': bloodType,
      'hospital': hospital,
      'isRead': isRead,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    final createdAtValue = map['createdAt'];

    return NotificationModel(
      id: map['id']?.toString() ?? '',
      receiverId: map['receiverId']?.toString() ?? '',
      receiverRole: map['receiverRole']?.toString() ?? '',
      requestId: map['requestId']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      body: map['body']?.toString() ?? '',
      patientName: map['patientName']?.toString() ?? '',
      bloodType: map['bloodType']?.toString() ?? '',
      hospital: map['hospital']?.toString() ?? '',
      isRead: map['isRead'] == true,
      createdAt: createdAtValue is Timestamp ? createdAtValue.toDate() : null,
    );
  }
}
