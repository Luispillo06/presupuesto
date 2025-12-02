import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_config.dart';
import '../../shared/models/gasto_model.dart';

/// Servicio para gestionar gastos con Supabase
class GastosService {
  final SupabaseClient _client = SupabaseConfig.client;
  static const String _tabla = 'gastos';

  /// Obtener todos los gastos del usuario actual
  Future<List<Gasto>> getGastos() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tabla)
        .select()
        .eq('user_id', userId)
        .order('fecha', ascending: false);

    return (response as List).map((json) => Gasto.fromJson(json)).toList();
  }

  /// Crear nuevo gasto
  Future<Gasto?> createGasto(Gasto gasto) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return null;

    final data = gasto.toJson();
    data['user_id'] = userId;

    final response = await _client.from(_tabla).insert(data).select().single();

    return Gasto.fromJson(response);
  }

  /// Actualizar gasto existente
  Future<Gasto?> updateGasto(Gasto gasto) async {
    if (gasto.id == null) return null;
    final response = await _client
        .from(_tabla)
        .update(gasto.toJson())
        .eq('id', gasto.id!)
        .select()
        .single();

    return Gasto.fromJson(response);
  }

  /// Eliminar gasto
  Future<void> deleteGasto(String id) async {
    await _client.from(_tabla).delete().eq('id', id);
  }

  /// Obtener gastos por categoría
  Future<List<Gasto>> getGastosByCategoria(String categoria) async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from(_tabla)
        .select()
        .eq('user_id', userId)
        .eq('categoria', categoria)
        .order('fecha', ascending: false);

    return (response as List).map((json) => Gasto.fromJson(json)).toList();
  }

  /// Obtener gastos por rango de fechas
  Future<List<Gasto>> getGastosByDateRange(
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

    return (response as List).map((json) => Gasto.fromJson(json)).toList();
  }

  /// Stream de gastos en tiempo real
  Stream<List<Gasto>> gastosStream() {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return Stream.value([]);

    return _client
        .from(_tabla)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('fecha', ascending: false)
        .map((data) => data.map((json) => Gasto.fromJson(json)).toList());
  }
}
