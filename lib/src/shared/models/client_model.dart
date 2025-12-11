/// Modelo de Cliente para el CRM
class ClientModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? company;
  final DateTime createdAt;
  final String? createdBy;

  ClientModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.company,
    required this.createdAt,
    this.createdBy,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      company: json['company'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'company': company,
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
    };
  }

  /// Para crear un nuevo cliente (sin id, se genera en DB)
  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'company': company,
      'created_by': createdBy,
    };
  }

  ClientModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? company,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  String toString() =>
      'ClientModel(id: $id, name: $name, email: $email, company: $company)';
}
