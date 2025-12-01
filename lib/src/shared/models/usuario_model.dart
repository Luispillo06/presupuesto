/// Modelo de datos para un Usuario
class Usuario {
  final String? id;
  final String email;
  final String? nombre;
  final String? nombreNegocio;
  final String? telefono;
  final DateTime? fechaCreacion;

  Usuario({
    this.id,
    required this.email,
    this.nombre,
    this.nombreNegocio,
    this.telefono,
    this.fechaCreacion,
  });

  /// Crear desde JSON (para Supabase Auth)
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String?,
      email: json['email'] as String,
      nombre: json['nombre'] as String?,
      nombreNegocio: json['nombre_negocio'] as String?,
      telefono: json['telefono'] as String?,
      fechaCreacion: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convertir a JSON (para Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'nombre': nombre,
      'nombre_negocio': nombreNegocio,
      'telefono': telefono,
    };
  }

  /// Crear copia con modificaciones
  Usuario copyWith({
    String? id,
    String? email,
    String? nombre,
    String? nombreNegocio,
    String? telefono,
    DateTime? fechaCreacion,
  }) {
    return Usuario(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      nombreNegocio: nombreNegocio ?? this.nombreNegocio,
      telefono: telefono ?? this.telefono,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return 'Usuario(id: $id, email: $email, nombre: $nombre)';
  }
}
