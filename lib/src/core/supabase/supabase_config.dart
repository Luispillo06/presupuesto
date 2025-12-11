import 'package:supabase_flutter/supabase_flutter.dart';

/// Configuración de Supabase para MarketMove
class SupabaseConfig {
  static const String supabaseUrl = 'https://enrfzuuolscflkcsengw.supabase.co';
  static const String supabaseAnonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVucmZ6dXVvbHNjZmxrY3Nlbmd3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU0NjQ2NTQsImV4cCI6MjA4MTA0MDY1NH0.RaZ3TOSvQTM7D5_wrASYCST6jtllD0GkBhwmGgRC8_0";

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
