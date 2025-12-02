import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_config.dart';
import '../../shared/models/venta_model.dart';

/// Servicio para gestionar ventas con Supabase
class VentasService {
  final SupabaseClient _client = SupabaseConfig.client;
  static const String _tabla = 'ventas';

  /// Obtener todas las ventas del usuario actual
  Future<List<Venta>> getVentas() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tabla)
        .select()
        .eq('user_id', userId)
        .order('fecha', ascending: false);

    return (response as List).map((json) => Venta.fromJson(json)).toList();
  }

  /// Crear nueva venta
  Future<Venta?> createVenta(Venta venta) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return null;

    final data = venta.toJson();
    data['user_id'] = userId;

    final response = await _client.from(_tabla).insert(data).select().single();

    return Venta.fromJson(response);
  }

  /// Actualizar venta existente
  Future<Venta?> updateVenta(Venta venta) async {
    if (venta.id == null) return null;
    final response = await _client
        .from(_tabla)
        .update(venta.toJson())
        .eq('id', venta.id!)
        .select()
        .single();

    return Venta.fromJson(response);
  }

  /// Eliminar venta
  Future<void> deleteVenta(String id) async {
    await _client.from(_tabla).delete().eq('id', id);
  }

  /// Obtener ventas por rango de fechas
  Future<List<Venta>> getVentasByDateRange(
    DateTime inicio,
    DateTime fin,
  ) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tabla)
        .select()
        .eq('user_id', userId)
        .gte('fecha', inicio.toIso8601String())
        .lte('fecha', fin.toIso8601String())
        .order('fecha', ascending: false);

    return (response as List).map((json) => Venta.fromJson(json)).toList();
  }

  /// Stream de ventas en tiempo real
  Stream<List<Venta>> ventasStream() {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return Stream.value([]);

    return _client
        .from(_tabla)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('fecha', ascending: false)
        .map((data) => data.map((json) => Venta.fromJson(json)).toList());
  }
}
