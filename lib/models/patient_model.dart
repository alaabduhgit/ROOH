class PatientModel {
  final String id;
  final String name;
  final String bloodType;
  final String phone;
  final int totalRequests;

  PatientModel({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.phone,
    required this.totalRequests,
  });

  PatientModel copyWith({
    String? id,
    String? name,
    String? bloodType,
    String? phone,
    int? totalRequests,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bloodType: bloodType ?? this.bloodType,
      phone: phone ?? this.phone,
      totalRequests: totalRequests ?? this.totalRequests,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bloodType': bloodType,
      'phone': phone,
      'totalRequests': totalRequests,
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      bloodType: map['bloodType']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      totalRequests: map['totalRequests'] is int
          ? map['totalRequests'] as int
          : int.tryParse(map['totalRequests']?.toString() ?? '') ?? 0,
    );
  }
}
