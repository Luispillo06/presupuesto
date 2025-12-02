import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_config.dart';

/// Servicio de autenticación con Supabase
class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Registrar nuevo usuario
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? nombre,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'nombre': nombre},
    );
    return response;
  }

  /// Iniciar sesión
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Recuperar contraseña
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  /// Obtener usuario actual
  User? get currentUser => _client.auth.currentUser;

  /// Stream de cambios en autenticación
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
