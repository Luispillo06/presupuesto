import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import '../../core/supabase/supabase_config.dart';

/// Servicio centralizado para todas las operaciones de datos
/// Captura TODAS las excepciones y retorna valores seguros
/// El programa NUNCA se detiene
class DataService {
  static final DataService _instance = DataService._internal();

  factory DataService() {
    return _instance;
  }

  DataService._internal();

  SupabaseClient get _client => SupabaseConfig.client;

  // ==================== PRODUCTOS ====================

  Future<List<Producto>> getProductos() async {
    try {
      final response = await _client.from('productos').select().order('nombre');
      return (response as List).map((json) => Producto.fromJson(json)).toList();
    } catch (e, stackTrace) {
      debugPrint('❌ Error getProductos: $e');
      debugPrint('   Stack: $stackTrace');
      return [];
    }
  }

  Future<Producto?> createProducto(Producto producto) async {
    try {
      final userId = SupabaseConfig.currentUser?.id;
      if (userId == null) {
        debugPrint('❌ Error createProducto: Usuario no autenticado');
        return null;
      }

      final data = producto.toJson();
      data['user_id'] = userId;

      final response = await _client
          .from('productos')
          .insert(data)
          .select()
          .single();
      return Producto.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('❌ Error createProducto: $e');
      debugPrint('   Stack: $stackTrace');
      return null;
    }
  }

  Future<Producto?> updateProducto(Producto producto) async {
    try {
      final response = await _client
          .from('productos')
          .update(producto.toJson())
          .eq('id', producto.id!)
          .select()
          .single();
      return Producto.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('❌ Error updateProducto: $e');
      debugPrint('   Stack: $stackTrace');
      return null;
    }
  }

  Future<bool> deleteProducto(int id) async {
    try {
      await _client.from('productos').delete().eq('id', id);
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Error deleteProducto: $e');
      debugPrint('   Stack: $stackTrace');
      return false;
    }
  }

  // ==================== VENTAS ====================

  Future<List<Venta>> getVentas() async {
    try {
      final response = await _client
          .from('ventas')
          .select()
          .order('fecha', ascending: false);
      return (response as List).map((json) => Venta.fromJson(json)).toList();
    } catch (e, stackTrace) {
      debugPrint('❌ Error getVentas: $e');
      debugPrint('   Stack: $stackTrace');
      return [];
    }
  }

  Future<Venta?> createVenta(Venta venta) async {
    try {
      final userId = SupabaseConfig.currentUser?.id;
      if (userId == null) {
        debugPrint('❌ Error createVenta: Usuario no autenticado');
        return null;
      }

      final data = venta.toJson();
      data['user_id'] = userId;

      // 1. Crear la venta
      final response = await _client
          .from('ventas')
          .insert(data)
          .select()
          .single();
      
      final nuevaVenta = Venta.fromJson(response);

      // 2. Descontar Stock (Lógica simple)
      // Parseamos strings como "Nombre Producto x2"
      for (final itemString in venta.productos) {
        try {
          // Buscamos el separador " x" desde el final
          final lastIndex = itemString.lastIndexOf(' x');
          if (lastIndex != -1) {
            final nombreProducto = itemString.substring(0, lastIndex);
            final cantidadStr = itemString.substring(lastIndex + 2);
            final cantidad = int.tryParse(cantidadStr) ?? 1;

            // Buscamos el producto por nombre (idealmente usaríamos ID, pero el modelo actual usa strings)
            // Esto asume nombres únicos por usuario, lo cual es razonable para este scope.
            final productoResp = await _client
                .from('productos')
                .select()
                .eq('user_id', userId)
                .eq('nombre', nombreProducto)
                .maybeSingle();

            if (productoResp != null) {
              final producto = Producto.fromJson(productoResp);
              final nuevoStock = producto.stock - cantidad;
              
              // Actualizamos stock
              await _client
                  .from('productos')
                  .update({'stock': nuevoStock})
                  .eq('id', producto.id!);
            }
          }
        } catch (e) {
          debugPrint('⚠️ Error al descontar stock para $itemString: $e');
        }
      }

      return nuevaVenta;
    } catch (e, stackTrace) {
      debugPrint('❌ Error createVenta: $e');
      debugPrint('   Stack: $stackTrace');
      return null;
    }
  }

  Future<Venta?> updateVenta(Venta venta) async {
    try {
      final response = await _client
          .from('ventas')
          .update(venta.toJson())
          .eq('id', venta.id!)
          .select()
          .single();
      return Venta.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('❌ Error updateVenta: $e');
      debugPrint('   Stack: $stackTrace');
      return null;
    }
  }

  Future<bool> deleteVenta(int id) async {
    try {
      await _client.from('ventas').delete().eq('id', id);
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Error deleteVenta: $e');
      debugPrint('   Stack: $stackTrace');
      return false;
    }
  }

  // ==================== GASTOS ====================

  Future<List<Gasto>> getGastos() async {
    try {
      final response = await _client
          .from('gastos')
          .select()
          .order('fecha', ascending: false);
      return (response as List).map((json) => Gasto.fromJson(json)).toList();
    } catch (e, stackTrace) {
      debugPrint('❌ Error getGastos: $e');
      debugPrint('   Stack: $stackTrace');
      return [];
    }
  }

  Future<Gasto?> createGasto(Gasto gasto) async {
    try {
      final userId = SupabaseConfig.currentUser?.id;
      if (userId == null) {
        debugPrint('❌ Error createGasto: Usuario no autenticado');
        return null;
      }

      final data = gasto.toJson();
      data['user_id'] = userId;

      final response = await _client
          .from('gastos')
          .insert(data)
          .select()
          .single();
      return Gasto.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('❌ Error createGasto: $e');
      debugPrint('   Stack: $stackTrace');
      return null;
    }
  }

  Future<Gasto?> updateGasto(Gasto gasto) async {
    try {
      final response = await _client
          .from('gastos')
          .update(gasto.toJson())
          .eq('id', gasto.id!)
          .select()
          .single();
      return Gasto.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('❌ Error updateGasto: $e');
      debugPrint('   Stack: $stackTrace');
      return null;
    }
  }

  Future<bool> deleteGasto(int id) async {
    try {
      await _client.from('gastos').delete().eq('id', id);
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Error deleteGasto: $e');
      debugPrint('   Stack: $stackTrace');
      return false;
    }
  }

  // ==================== RESUMEN ====================

  Future<double> getTotalVentasDelDia() async {
    try {
      final hoy = DateTime.now();
      final inicio = DateTime(hoy.year, hoy.month, hoy.day);
      final fin = inicio.add(const Duration(days: 1));

      final response = await _client
          .from('ventas')
          .select()
          .gte('fecha', inicio.toIso8601String())
          .lt('fecha', fin.toIso8601String());

      final ventas = (response as List)
          .map((json) => Venta.fromJson(json))
          .toList();
      return ventas.fold<double>(0, (sum, v) => sum + v.monto);
    } catch (e, stackTrace) {
      debugPrint('❌ Error getTotalVentasDelDia: $e');
      debugPrint('   Stack: $stackTrace');
      return 0.0;
    }
  }

  Future<double> getTotalGastosDelDia() async {
    try {
      final hoy = DateTime.now();
      final inicio = DateTime(hoy.year, hoy.month, hoy.day);
      final fin = inicio.add(const Duration(days: 1));

      final response = await _client
          .from('gastos')
          .select()
          .gte('fecha', inicio.toIso8601String())
          .lt('fecha', fin.toIso8601String());

      final gastos = (response as List)
          .map((json) => Gasto.fromJson(json))
          .toList();
      return gastos.fold<double>(0, (sum, g) => sum + g.monto);
    } catch (e, stackTrace) {
      debugPrint('❌ Error getTotalGastosDelDia: $e');
      debugPrint('   Stack: $stackTrace');
      return 0.0;
    }
  }

  Future<double> getBalanceDelDia() async {
    try {
      final ventas = await getTotalVentasDelDia();
      final gastos = await getTotalGastosDelDia();
      return ventas - gastos;
    } catch (e, stackTrace) {
      debugPrint('❌ Error getBalanceDelDia: $e');
      debugPrint('   Stack: $stackTrace');
      return 0.0;
    }
  }

  Future<int> getTotalProductos() async {
    try {
      final productos = await getProductos();
      return productos.length;
    } catch (e, stackTrace) {
      debugPrint('❌ Error getTotalProductos: $e');
      debugPrint('   Stack: $stackTrace');
      return 0;
    }
  }

  Future<int> getTotalProductosStockBajo() async {
    try {
      final productos = await getProductos();
      return productos.where((p) => p.stockBajo).length;
    } catch (e, stackTrace) {
      debugPrint('❌ Error getTotalProductosStockBajo: $e');
      debugPrint('   Stack: $stackTrace');
      return 0;
    }
  }
}
