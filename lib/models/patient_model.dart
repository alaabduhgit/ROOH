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
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      bloodType: map['bloodType'] ?? '',
      phone: map['phone'] ?? '',
      totalRequests: map['totalRequests'] ?? 0,
    );
  }
}
