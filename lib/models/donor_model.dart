import 'package:cloud_firestore/cloud_firestore.dart';

class DonorModel {
  final String id;
  final String name;
  final String phone;
  final String bloodType;
  final String city;
  final int age;
  final bool isAvailable;
  final int donationReadiness;
  final DateTime? lastDonationDate;

  DonorModel({
    required this.id,
    required this.name,
    this.phone = '',
    required this.bloodType,
    this.city = '',
    this.age = 0,
    this.isAvailable = false,
    this.donationReadiness = 100,
    this.lastDonationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'bloodType': bloodType,
      'city': city,
      'age': age,
      'isAvailable': isAvailable,
      'donationReadiness': donationReadiness,
      'lastDonationDate': lastDonationDate,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory DonorModel.fromMap(Map<String, dynamic> map) {
    return DonorModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      bloodType: map['bloodType'] ?? '',
      city: map['city'] ?? '',
      age: map['age'] ?? 0,
      isAvailable: map['isAvailable'] ?? false,
      donationReadiness: map['donationReadiness'] ?? 100,
      lastDonationDate: map['lastDonationDate'] == null
          ? null
          : (map['lastDonationDate'] as Timestamp).toDate(),
    );
  }
}
