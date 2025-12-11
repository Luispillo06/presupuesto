import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_config.dart';
import '../../shared/models/compra_model.dart';

/// Servicio para gestionar compras (buyer) con Supabase
class ComprasService {
  final SupabaseClient _client = SupabaseConfig.client;
  static const String _tabla = 'compras';

  /// Obtener todas las compras del usuario actual (como comprador)
  Future<List<Compra>> getComprasUsuario() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from(_tabla)
          .select('*, productos(*), vendor:vendor_id(nombre, email)')
          .eq('buyer_id', userId)
          .order('fecha_compra', ascending: false);

      return (response as List).map((json) => Compra.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener compras: ${e.toString()}');
    }
  }

  /// Obtener compras de un usuario como vendedor (compras recibidas)
  Future<List<Compra>> getComprasRecibidas() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from(_tabla)
          .select('*, productos(*), buyer:buyer_id(nombre, email)')
          .eq('vendor_id', userId)
          .order('fecha_compra', ascending: false);

      return (response as List).map((json) => Compra.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener compras recibidas: ${e.toString()}');
    }
  }

  /// Obtener una compra específica
  Future<Compra?> getCompra(int id) async {
    try {
      final response = await _client
          .from(_tabla)
          .select('*, productos(*), vendor:vendor_id(nombre, email)')
          .eq('id', id)
          .single();

      return Compra.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Crear nueva compra
  Future<Compra?> createCompra({
    required String vendorId,
    required int productoId,
    required int cantidad,
    required double precioUnitario,
    required double precioTotal,
  }) async {
    final buyerId = SupabaseConfig.currentUser?.id;
    if (buyerId == null) return null;

    try {
      final compra = Compra(
        buyerId: buyerId,
        vendorId: vendorId,
        productoId: productoId,
        cantidad: cantidad,
        precioUnitario: precioUnitario,
        precioTotal: precioTotal,
        estado: 'pendiente',
        fechaCompra: DateTime.now(),
      );

      final response = await _client
          .from(_tabla)
          .insert(compra.toJson())
          .select()
          .single();

      return Compra.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear compra: ${e.toString()}');
    }
  }

  /// Actualizar estado de compra
  Future<Compra?> updateEstadoCompra(int id, String nuevoEstado) async {
    try {
      final response = await _client
          .from(_tabla)
          .update({'estado': nuevoEstado})
          .eq('id', id)
          .select()
          .single();

      return Compra.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar compra: ${e.toString()}');
    }
  }

  /// Cancelar compra (solo como comprador)
  Future<bool> cancelarCompra(int id) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return false;

    try {
      await _client
          .from(_tabla)
          .update({'estado': 'cancelado'})
          .eq('id', id)
          .eq('buyer_id', userId);

      return true;
    } catch (e) {
      throw Exception('Error al cancelar compra: ${e.toString()}');
    }
  }

  /// Confirmar compra (vendedor)
  Future<bool> confirmarCompra(int id) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return false;

    try {
      await _client
          .from(_tabla)
          .update({'estado': 'confirmado'})
          .eq('id', id)
          .eq('vendor_id', userId);

      return true;
    } catch (e) {
      throw Exception('Error al confirmar compra: ${e.toString()}');
    }
  }

  /// Eliminar compra
  Future<bool> deleteCompra(int id) async {
    try {
      await _client.from(_tabla).delete().eq('id', id);
      return true;
    } catch (e) {
      throw Exception('Error al eliminar compra: ${e.toString()}');
    }
  }

  /// Obtener compras por estado
  Future<List<Compra>> getComprasByEstado(String estado) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from(_tabla)
          .select('*, productos(*), vendor:vendor_id(nombre, email)')
          .eq('buyer_id', userId)
          .eq('estado', estado)
          .order('fecha_compra', ascending: false);

      return (response as List).map((json) => Compra.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Obtener compras por rango de fechas
  Future<List<Compra>> getComprasByDateRange(
    DateTime inicio,
    DateTime fin,
  ) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from(_tabla)
          .select('*, productos(*), vendor:vendor_id(nombre, email)')
          .eq('buyer_id', userId)
          .gte('fecha_compra', inicio.toIso8601String())
          .lte('fecha_compra', fin.toIso8601String())
          .order('fecha_compra', ascending: false);

      return (response as List).map((json) => Compra.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Stream de compras en tiempo real
  Stream<List<Compra>> comprasStream() {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return Stream.value([]);

    return _client
        .from(_tabla)
        .stream(primaryKey: ['id'])
        .eq('buyer_id', userId)
        .order('fecha_compra', ascending: false)
        .map((data) => data.map((json) => Compra.fromJson(json)).toList());
  }

  /// Obtener total de compras del usuario
  Future<double> getTotalCompras() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return 0;

    try {
      final response = await _client
          .from(_tabla)
          .select('precio_total')
          .eq('buyer_id', userId);

      double total = 0;
      for (var item in response as List) {
        total += (item['precio_total'] as num).toDouble();
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  /// Obtener cantidad de compras por estado
  Future<Map<String, int>> getComprasCountByEstado() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return {};

    try {
      final response = await _client
          .from(_tabla)
          .select()
          .eq('buyer_id', userId);

      Map<String, int> counts = {
        'pendiente': 0,
        'confirmado': 0,
        'entregado': 0,
        'cancelado': 0,
      };

      for (var item in response as List) {
        final estado = item['estado'] as String;
        counts[estado] = (counts[estado] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      return {};
    }
  }

  /// Obtener total de compras pendientes (para vendedor)
  Future<int> getTotalComprasPendientes() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return 0;

    try {
      final response = await _client
          .from(_tabla)
          .select('id')
          .eq('vendor_id', userId)
          .eq('estado', 'pendiente');

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }
}
