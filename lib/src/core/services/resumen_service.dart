import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_config.dart';

/// Modelo para el resumen/balance del vendedor
class ResumenVendedor {
  final double totalGanancias;
  final double totalGastos;
  final double balanceNeto;
  final int totalVentas;
  final int totalGastosRegistrados;

  ResumenVendedor({
    required this.totalGanancias,
    required this.totalGastos,
    required this.balanceNeto,
    required this.totalVentas,
    required this.totalGastosRegistrados,
  });

  factory ResumenVendedor.fromJson(Map<String, dynamic> json) {
    return ResumenVendedor(
      totalGanancias: (json['total_ganancias'] as num?)?.toDouble() ?? 0.0,
      totalGastos: (json['total_gastos'] as num?)?.toDouble() ?? 0.0,
      balanceNeto: (json['balance_neto'] as num?)?.toDouble() ?? 0.0,
      totalVentas: json['total_ventas'] as int? ?? 0,
      totalGastosRegistrados: json['total_gastos_registrados'] as int? ?? 0,
    );
  }
}

/// Servicio para obtener el resumen/balance del vendedor
class ResumenService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Obtener resumen total del usuario actual
  Future<ResumenVendedor?> getResumenActual() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await _client
          .from('vista_resumen_usuario')
          .select()
          .eq('user_id', userId)
          .single();

      return ResumenVendedor.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Obtener balance diario
  Future<List<Map<String, dynamic>>> getBalanceDiario() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from('vista_balance_vendedor')
          .select()
          .eq('user_id', userId)
          .order('fecha', ascending: false)
          .limit(30); // Últimos 30 días

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  /// Stream de resumen en tiempo real
  Stream<ResumenVendedor?> getResumenStream() {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) return Stream.value(null);

    return _client
        .from('vista_resumen_usuario')
        .stream(primaryKey: ['user_id'])
        .eq('user_id', userId)
        .map((data) {
          if (data.isEmpty) return null;
          return ResumenVendedor.fromJson(data.first);
        })
        .handleError((error) {
          return null;
        });
  }
}
