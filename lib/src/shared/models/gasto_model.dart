/// Modelo de datos para un Gasto
class Gasto {
  final int? id;
  final String concepto;
  final String categoria;
  final double monto;
  final DateTime fecha;
  final String? notas;

  Gasto({
    this.id,
    required this.concepto,
    required this.categoria,
    required this.monto,
    required this.fecha,
    this.notas,
  });

  /// Categorías predefinidas de gastos
  static const List<String> categorias = [
    'Proveedores',
    'Servicios',
    'Personal',
    'Alquiler',
    'Impuestos',
    'Marketing',
    'Otros',
  ];

  /// Crear desde JSON (para Supabase)
  factory Gasto.fromJson(Map<String, dynamic> json) {
    return Gasto(
      id: json['id'] as int?,
      concepto: json['concepto'] as String,
      categoria: json['categoria'] as String,
      monto: (json['monto'] as num).toDouble(),
      fecha: DateTime.parse(json['fecha'] as String),
      notas: json['notas'] as String?,
    );
  }

  /// Convertir a JSON (para Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'concepto': concepto,
      'categoria': categoria,
      'monto': monto,
      'fecha': fecha.toIso8601String(),
      'notas': notas,
    };
  }

  /// Crear copia con modificaciones
  Gasto copyWith({
    int? id,
    String? concepto,
    String? categoria,
    double? monto,
    DateTime? fecha,
    String? notas,
  }) {
    return Gasto(
      id: id ?? this.id,
      concepto: concepto ?? this.concepto,
      categoria: categoria ?? this.categoria,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      notas: notas ?? this.notas,
    );
  }

  @override
  String toString() {
    return 'Gasto(id: $id, concepto: $concepto, categoria: $categoria, monto: $monto)';
  }
}
