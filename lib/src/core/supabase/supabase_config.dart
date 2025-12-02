import 'package:supabase_flutter/supabase_flutter.dart';

/// Configuración de Supabase para MarketMove
class SupabaseConfig {
  // TODO: Reemplazar con tus credenciales de Supabase
  static const String supabaseUrl = 'https://TU_PROYECTO.supabase.co';
  static const String supabaseAnonKey = 'TU_ANON_KEY';

  /// Cliente de Supabase (singleton)
  static SupabaseClient get client => Supabase.instance.client;

  /// Inicializa Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  /// Usuario actual autenticado
  static User? get currentUser => client.auth.currentUser;

  /// Verifica si hay un usuario autenticado
  static bool get isAuthenticated => currentUser != null;

  /// Stream de cambios en el estado de autenticación
  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;
}
