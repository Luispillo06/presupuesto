/// Modelo de datos para un Producto
class Producto {
  final int? id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final int stock;
  final int stockMinimo;
  final String categoria;
  final String? codigoBarras;
  final String? imagenUrl;

  Producto({
    this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.stock,
    this.stockMinimo = 5,
    required this.categoria,
    this.codigoBarras,
    this.imagenUrl,
  });

  /// Verificar si el stock está bajo
  bool get stockBajo => stock <= stockMinimo;

  /// Valor del inventario de este producto
  double get valorInventario => precio * stock;

  /// Crear desde JSON (para Supabase)
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int?,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      precio: (json['precio'] as num).toDouble(),
      stock: json['stock'] as int,
      stockMinimo: json['stock_minimo'] as int? ?? 5,
      categoria: json['categoria'] as String,
      codigoBarras: json['codigo_barras'] as String?,
      imagenUrl: json['imagen_url'] as String?,
    );
  }

  /// Convertir a JSON (para Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'stock_minimo': stockMinimo,
      'categoria': categoria,
      'codigo_barras': codigoBarras,
      'imagen_url': imagenUrl,
    };
  }

  /// Crear copia con modificaciones
  Producto copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    double? precio,
    int? stock,
    int? stockMinimo,
    String? categoria,
    String? codigoBarras,
    String? imagenUrl,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      categoria: categoria ?? this.categoria,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      imagenUrl: imagenUrl ?? this.imagenUrl,
    );
  }

  @override
  String toString() {
    return 'Producto(id: $id, nombre: $nombre, precio: $precio, stock: $stock)';
  }
}
