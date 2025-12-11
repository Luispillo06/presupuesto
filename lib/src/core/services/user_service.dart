import '../supabase/supabase_config.dart';

/// Servicio para obtener información del usuario
class UserService {
  /// Obtener el rol del usuario actual (vendor o buyer)
  static Future<String> getRolUsuarioActual() async {
    try {
      final user = SupabaseConfig.currentUser;
      if (user == null) throw Exception('No hay usuario autenticado');

      final rol = user.userMetadata?['role'] as String?;

      // Si no hay rol en metadata, retornar vendor por defecto
      return rol ?? 'vendor';
    } catch (e) {
      throw Exception('Error obteniendo rol: $e');
    }
  }

  /// Obtener nombre del usuario
  static Future<String> getNombreUsuario() async {
    try {
      final user = SupabaseConfig.currentUser;
      if (user == null) throw Exception('No hay usuario autenticado');

      final nombre = user.userMetadata?['nombre'] as String?;
      return nombre ?? user.email ?? 'Usuario';
    } catch (e) {
      throw Exception('Error obteniendo nombre: $e');
    }
  }

  /// Obtener email del usuario
  static String? getEmailUsuario() {
    return SupabaseConfig.currentUser?.email;
  }

  /// Verificar si el usuario es vendedor
  static Future<bool> esVendedor() async {
    final rol = await getRolUsuarioActual();
    return rol == 'vendor';
  }

  /// Verificar si el usuario es comprador
  static Future<bool> esComprador() async {
    final rol = await getRolUsuarioActual();
    return rol == 'buyer';
  }
}
