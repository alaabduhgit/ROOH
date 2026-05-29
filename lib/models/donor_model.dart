class Donor_model {
  // 1. الخصائص (Properties)
  final String id;
  final String name;
  final String bloodType;
  final bool isAvailable;

  // 2. المُنشئ (Constructor)
  Donor_model({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.isAvailable,
  });

  // 3. دالة المخرجات لقاعدة البيانات: تحول الكائن (Object) إلى خريطة (Map/JSON) ليفهمها Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bloodType': bloodType,
      'isAvailable': isAvailable,
    };
  }

  // 4. دالة المستقبلات من قاعدة البيانات: تأخذ الخريطة (Map) القادمة من Firebase وتحولها إلى كائن Dart
  factory Donor_model.fromMap(Map<String, dynamic> map) {
    return Donor_model(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      bloodType: map['bloodType'] ?? '',
      isAvailable:
          map['isAvailable'] ??
          false, // إذا كانت القيمة فارغة في فايربيز، ستكون القيمة الافتراضية false
    );
  }
}
