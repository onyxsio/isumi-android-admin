const String tableAdmin = 'Admin';

class AdminFields {
  static final List<String> values = [
    /// Add all fields
    id, name, address, email, slogan, phone,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String email = 'email';
  static const String address = 'address';
  static const String slogan = 'slogan';
  static const String phone = 'phone';
}

class Admin {
  final int? id;
  final String address;
  final String name;
  final String email;
  final String slogan;
  final String phone;

  const Admin({
    this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.slogan,
    required this.phone,
  });

  Admin copy({
    int? id,
    String? name,
    String? address,
    String? email,
    String? slogan,
    String? phone,
  }) =>
      Admin(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        email: email ?? this.email,
        slogan: slogan ?? this.slogan,
        phone: phone ?? this.phone,
      );

  static Admin fromJson(Map<String, Object?> json) => Admin(
        id: json[AdminFields.id] as int?,
        name: json[AdminFields.name] as String,
        address: json[AdminFields.address] as String,
        email: json[AdminFields.email] as String,
        slogan: json[AdminFields.slogan] as String,
        phone: json[AdminFields.phone] as String,
      );

  Map<String, Object?> toJson() => {
        AdminFields.id: id,
        AdminFields.name: name,
        AdminFields.address: address,
        AdminFields.email: email,
        AdminFields.slogan: slogan,
        AdminFields.phone: phone,
      };
}
