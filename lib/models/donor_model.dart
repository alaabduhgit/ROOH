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

  DonorModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? bloodType,
    String? city,
    int? age,
    bool? isAvailable,
    int? donationReadiness,
    DateTime? lastDonationDate,
  }) {
    return DonorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      bloodType: bloodType ?? this.bloodType,
      city: city ?? this.city,
      age: age ?? this.age,
      isAvailable: isAvailable ?? this.isAvailable,
      donationReadiness: donationReadiness ?? this.donationReadiness,
      lastDonationDate: lastDonationDate ?? this.lastDonationDate,
    );
  }

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
      'lastDonationDate': lastDonationDate == null
          ? null
          : Timestamp.fromDate(lastDonationDate!),
    };
  }

  factory DonorModel.fromMap(Map<String, dynamic> map) {
    final dynamic lastDate = map['lastDonationDate'];

    return DonorModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      bloodType: map['bloodType']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      age: map['age'] is int
          ? map['age'] as int
          : int.tryParse(map['age']?.toString() ?? '') ?? 0,
      isAvailable: map['isAvailable'] == true,
      donationReadiness: map['donationReadiness'] is int
          ? map['donationReadiness'] as int
          : int.tryParse(map['donationReadiness']?.toString() ?? '') ?? 100,
      lastDonationDate: lastDate is Timestamp ? lastDate.toDate() : null,
    );
  }
}
