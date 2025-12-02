import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_config.dart';
import '../../shared/models/producto_model.dart';

/// Servicio para gestionar productos/inventario con Supabase
class ProductosService {
  final SupabaseClient _client = SupabaseConfig.client;
  static const String _tabla = 'productos';

  /// Obtener todos los productos del usuario actual
  Future<List<Producto>> getProductos() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tabla)
        .select()
        .eq('user_id', userId)
        .order('nombre', ascending: true);

    return (response as List).map((json) => Producto.fromJson(json)).toList();
  }

  /// Crear nuevo producto
  Future<Producto?> createProducto(Producto producto) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return null;

    final data = producto.toJson();
    data['user_id'] = userId;

    final response = await _client.from(_tabla).insert(data).select().single();

    return Producto.fromJson(response);
  }

  /// Actualizar producto existente
  Future<Producto?> updateProducto(Producto producto) async {
    if (producto.id == null) return null;
    final response = await _client
        .from(_tabla)
        .update(producto.toJson())
        .eq('id', producto.id!)
        .select()
        .single();

    return Producto.fromJson(response);
  }

  /// Eliminar producto
  Future<void> deleteProducto(String id) async {
    await _client.from(_tabla).delete().eq('id', id);
  }

  /// Obtener productos con stock bajo
  Future<List<Producto>> getProductosStockBajo(int stockMinimo) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tabla)
        .select()
        .eq('user_id', userId)
        .lte('stock', stockMinimo)
        .order('stock', ascending: true);

    return (response as List).map((json) => Producto.fromJson(json)).toList();
  }

  /// Actualizar stock de un producto
  Future<void> updateStock(String id, int nuevoStock) async {
    await _client.from(_tabla).update({'stock': nuevoStock}).eq('id', id);
  }

  /// Buscar productos por nombre
  Future<List<Producto>> searchProductos(String query) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tabla)
        .select()
        .eq('user_id', userId)
        .ilike('nombre', '%$query%')
        .order('nombre', ascending: true);

    return (response as List).map((json) => Producto.fromJson(json)).toList();
  }

  /// Stream de productos en tiempo real
  Stream<List<Producto>> productosStream() {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return Stream.value([]);

    return _client
        .from(_tabla)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('nombre', ascending: true)
        .map((data) => data.map((json) => Producto.fromJson(json)).toList());
  }
}
