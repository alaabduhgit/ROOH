import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String id;
  final String patientId;
  final String patientName;
  final String patientPhone;
  final String bloodType;
  final String hospital;
  final String location;
  final String notes;
  final String status;
  final String? acceptedByDonorId;
  final String? acceptedByDonorName;
  final String? acceptedByDonorPhone;
  final List<String> rejectedByDonors;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RequestModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    required this.bloodType,
    required this.hospital,
    required this.location,
    required this.notes,
    this.status = 'pending',
    this.acceptedByDonorId,
    this.acceptedByDonorName,
    this.acceptedByDonorPhone,
    this.rejectedByDonors = const [],
    this.createdAt,
    this.updatedAt,
  });

  RequestModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? patientPhone,
    String? bloodType,
    String? hospital,
    String? location,
    String? notes,
    String? status,
    String? acceptedByDonorId,
    String? acceptedByDonorName,
    String? acceptedByDonorPhone,
    List<String>? rejectedByDonors,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RequestModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      bloodType: bloodType ?? this.bloodType,
      hospital: hospital ?? this.hospital,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      acceptedByDonorId: acceptedByDonorId ?? this.acceptedByDonorId,
      acceptedByDonorName: acceptedByDonorName ?? this.acceptedByDonorName,
      acceptedByDonorPhone: acceptedByDonorPhone ?? this.acceptedByDonorPhone,
      rejectedByDonors: rejectedByDonors ?? this.rejectedByDonors,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'patientPhone': patientPhone,
      'bloodType': bloodType,
      'hospital': hospital,
      'location': location,
      'notes': notes,
      'status': status,
      'acceptedByDonorId': acceptedByDonorId,
      'acceptedByDonorName': acceptedByDonorName,
      'acceptedByDonorPhone': acceptedByDonorPhone,
      'rejectedByDonors': rejectedByDonors,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    final createdAtValue = map['createdAt'];
    final updatedAtValue = map['updatedAt'];
    final rejectedValue = map['rejectedByDonors'];

    return RequestModel(
      id: map['id']?.toString() ?? '',
      patientId: map['patientId']?.toString() ?? '',
      patientName: map['patientName']?.toString() ?? '',
      patientPhone: map['patientPhone']?.toString() ?? '',
      bloodType: map['bloodType']?.toString() ?? '',
      hospital: map['hospital']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      notes: map['notes']?.toString() ?? '',
      status: map['status']?.toString() ?? 'pending',
      acceptedByDonorId: map['acceptedByDonorId']?.toString(),
      acceptedByDonorName: map['acceptedByDonorName']?.toString(),
      acceptedByDonorPhone: map['acceptedByDonorPhone']?.toString(),
      rejectedByDonors: rejectedValue is List
          ? rejectedValue.map((item) => item.toString()).toList()
          : const [],
      createdAt: createdAtValue is Timestamp ? createdAtValue.toDate() : null,
      updatedAt: updatedAtValue is Timestamp ? updatedAtValue.toDate() : null,
    );
  }
}
