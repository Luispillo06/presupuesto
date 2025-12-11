/// Modelo de Perfil de Usuario para el CRM
class ProfileModel {
  final String id;
  final String fullName;
  final String role;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.role,
    required this.createdAt,
  });

  /// Verifica si el usuario es administrador
  bool get isAdmin => role == 'admin';

  /// Verifica si el usuario es staff
  bool get isStaff => role == 'staff';

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? 'Usuario',
      role: json['role'] ?? 'staff',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? fullName,
    String? role,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'ProfileModel(id: $id, fullName: $fullName, role: $role)';
}
