/// Modelo de datos para una Venta
class Venta {
  final int? id;
  final String cliente;
  final double monto;
  final DateTime fecha;
  final List<String> productos;
  final String? notas;

  Venta({
    this.id,
    required this.cliente,
    required this.monto,
    required this.fecha,
    required this.productos,
    this.notas,
  });

  /// Crear desde JSON (para Supabase)
  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      id: json['id'] as int?,
      cliente: json['cliente'] as String,
      monto: (json['monto'] as num).toDouble(),
      fecha: DateTime.parse(json['fecha'] as String),
      productos: List<String>.from(json['productos'] as List),
      notas: json['notas'] as String?,
    );
  }

  /// Convertir a JSON (para Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'cliente': cliente,
      'monto': monto,
      'fecha': fecha.toIso8601String(),
      'productos': productos,
      'notas': notas,
    };
  }

  /// Crear copia con modificaciones
  Venta copyWith({
    int? id,
    String? cliente,
    double? monto,
    DateTime? fecha,
    List<String>? productos,
    String? notas,
  }) {
    return Venta(
      id: id ?? this.id,
      cliente: cliente ?? this.cliente,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      productos: productos ?? this.productos,
      notas: notas ?? this.notas,
    );
  }

  @override
  String toString() {
    return 'Venta(id: $id, cliente: $cliente, monto: $monto, fecha: $fecha)';
  }
}
