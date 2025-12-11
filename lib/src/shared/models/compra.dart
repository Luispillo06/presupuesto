import 'package:intl/intl.dart';

/// Modelo de Compra (Pedido de Comprador)
class Compra {
  final int? id;
  final String buyerId;
  final String vendorId;
  final int productoId;
  final int cantidad;
  final double precioUnitario;
  final double precioTotal;
  final String estado; // pendiente, confirmado, entregado, cancelado
  final DateTime fechaCompra;
  final String? nombreProducto;
  final String? nombreVendor;

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
    this.nombreProducto,
    this.nombreVendor,
  });

  /// Convertir desde JSON
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
      nombreProducto: json['nombre_producto'] as String?,
      nombreVendor: json['nombre_vendor'] as String?,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
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

  /// Obtener fecha formateada
  String get fechaFormateada {
    return DateFormat('dd/MM/yyyy HH:mm').format(fechaCompra);
  }

  /// Obtener estado en español
  String get estadoEspanol {
    switch (estado) {
      case 'pendiente':
        return '⏳ Pendiente';
      case 'confirmado':
        return '✅ Confirmado';
      case 'entregado':
        return '🎁 Entregado';
      case 'cancelado':
        return '❌ Cancelado';
      default:
        return estado;
    }
  }

  @override
  String toString() =>
      'Compra(id: $id, producto: $productoId, cantidad: $cantidad, total: $precioTotal)';
}
