/// Modelo de datos para una Compra (comprador hace compra a vendedor)
class Compra {
  final int? id;
  final String buyerId; // Usuario que compra
  final String vendorId; // Usuario que vende
  final int productoId; // ID del producto
  final int cantidad;
  final double precioUnitario;
  final double precioTotal;
  final String estado; // pendiente, confirmado, entregado, cancelado
  final DateTime fechaCompra;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relaciones (opcional para mostrar detalles)
  final Map<String, dynamic>? productoData;
  final Map<String, dynamic>? vendorData;

  Compra({
    this.id,
    required this.buyerId,
    required this.vendorId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.precioTotal,
    this.estado = 'pendiente',
    required this.fechaCompra,
    this.createdAt,
    this.updatedAt,
    this.productoData,
    this.vendorData,
  });

  /// Verificar si la compra está activa
  bool get isActive => estado != 'cancelado';

  /// Verificar si la compra está entregada
  bool get isEntregada => estado == 'entregado';

  /// Verificar si la compra está pendiente
  bool get isPendiente => estado == 'pendiente';

  /// Obtener el estado en español
  String get estadoEspanol {
    switch (estado) {
      case 'pendiente':
        return 'Pendiente';
      case 'confirmado':
        return 'Confirmado';
      case 'entregado':
        return 'Entregado';
      case 'cancelado':
        return 'Cancelado';
      default:
        return estado;
    }
  }

  /// Obtener la fecha formateada
  String get fechaFormateada {
    return '${fechaCompra.day}/${fechaCompra.month}/${fechaCompra.year} ${fechaCompra.hour}:${fechaCompra.minute.toString().padLeft(2, '0')}';
  }

  /// Crear desde JSON (para Supabase)
  factory Compra.fromJson(Map<String, dynamic> json) {
    return Compra(
      id: json['id'] as int?,
      buyerId: json['buyer_id'] as String,
      vendorId: json['vendor_id'] as String,
      productoId: json['producto_id'] as int,
      cantidad: json['cantidad'] as int? ?? 1,
      precioUnitario: (json['precio_unitario'] as num).toDouble(),
      precioTotal: (json['precio_total'] as num).toDouble(),
      estado: json['estado'] as String? ?? 'pendiente',
      fechaCompra: DateTime.parse(json['fecha_compra'] as String),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      productoData: json['productos'] as Map<String, dynamic>?,
      vendorData: json['vendor'] as Map<String, dynamic>?,
    );
  }

  /// Convertir a JSON (para Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'buyer_id': buyerId,
      'vendor_id': vendorId,
      'producto_id': productoId,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
      'precio_total': precioTotal,
      'estado': estado,
      'fecha_compra': fechaCompra.toIso8601String(),
    };
  }

  /// Crear una copia con parámetros opcionales modificados
  Compra copyWith({
    int? id,
    String? buyerId,
    String? vendorId,
    int? productoId,
    int? cantidad,
    double? precioUnitario,
    double? precioTotal,
    String? estado,
    DateTime? fechaCompra,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? productoData,
    Map<String, dynamic>? vendorData,
  }) {
    return Compra(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      vendorId: vendorId ?? this.vendorId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      precioTotal: precioTotal ?? this.precioTotal,
      estado: estado ?? this.estado,
      fechaCompra: fechaCompra ?? this.fechaCompra,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productoData: productoData ?? this.productoData,
      vendorData: vendorData ?? this.vendorData,
    );
  }

  @override
  String toString() =>
      'Compra(id: $id, buyerId: $buyerId, vendorId: $vendorId, '
      'productoId: $productoId, cantidad: $cantidad, precioTotal: $precioTotal, '
      'estado: $estado, fechaCompra: $fechaCompra)';
}
