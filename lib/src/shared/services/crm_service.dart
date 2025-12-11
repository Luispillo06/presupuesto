import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../models/client_model.dart';
import '../models/crm_product_model.dart';
import '../models/license_model.dart';

/// Servicio para gestionar operaciones del CRM con Supabase
class CrmService {
  final SupabaseClient _client = Supabase.instance.client;

  // =====================================================
  // AUTENTICACIÓN Y PERFIL
  // =====================================================

  /// Usuario actual
  User? get currentUser => _client.auth.currentUser;

  /// Verifica si hay usuario autenticado
  bool get isAuthenticated => currentUser != null;

  /// Iniciar sesión con email y contraseña
  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Registrar nuevo usuario con rol
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String role = 'staff',
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'role': role},
    );
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Obtener perfil del usuario actual
  Future<ProfileModel?> getCurrentProfile() async {
    if (currentUser == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', currentUser!.id)
        .maybeSingle();

    if (response == null) return null;
    return ProfileModel.fromJson(response);
  }

  /// Obtener todos los perfiles
  Future<List<ProfileModel>> getAllProfiles() async {
    final response = await _client
        .from('profiles')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ProfileModel.fromJson(json))
        .toList();
  }

  // =====================================================
  // CLIENTES
  // =====================================================

  /// Obtener todos los clientes
  Future<List<ClientModel>> getClients() async {
    final response = await _client
        .from('clients')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ClientModel.fromJson(json))
        .toList();
  }

  /// Obtener cliente por ID
  Future<ClientModel?> getClientById(String id) async {
    final response = await _client
        .from('clients')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return ClientModel.fromJson(response);
  }

  /// Crear cliente
  Future<ClientModel> createClient(ClientModel client) async {
    final response = await _client
        .from('clients')
        .insert(client.toInsertJson())
        .select()
        .single();

    return ClientModel.fromJson(response);
  }

  /// Actualizar cliente
  Future<ClientModel> updateClient(ClientModel client) async {
    final response = await _client
        .from('clients')
        .update({
          'name': client.name,
          'email': client.email,
          'phone': client.phone,
          'company': client.company,
        })
        .eq('id', client.id)
        .select()
        .single();

    return ClientModel.fromJson(response);
  }

  /// Eliminar cliente
  Future<void> deleteClient(String id) async {
    await _client.from('clients').delete().eq('id', id);
  }

  /// Contar clientes
  Future<int> countClients() async {
    final response = await _client
        .from('clients')
        .select('id')
        .count(CountOption.exact);
    return response.count;
  }

  // =====================================================
  // PRODUCTOS
  // =====================================================

  /// Obtener todos los productos
  Future<List<CrmProductModel>> getProducts() async {
    final response = await _client
        .from('crm_products')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => CrmProductModel.fromJson(json))
        .toList();
  }

  /// Obtener producto por ID
  Future<CrmProductModel?> getProductById(String id) async {
    final response = await _client
        .from('crm_products')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return CrmProductModel.fromJson(response);
  }

  /// Crear producto
  Future<CrmProductModel> createProduct(CrmProductModel product) async {
    final response = await _client
        .from('crm_products')
        .insert(product.toInsertJson())
        .select()
        .single();

    return CrmProductModel.fromJson(response);
  }

  /// Actualizar producto
  Future<CrmProductModel> updateProduct(CrmProductModel product) async {
    final response = await _client
        .from('crm_products')
        .update({
          'name': product.name,
          'description': product.description,
          'price_one_payment': product.priceOnePayment,
          'price_subscription': product.priceSubscription,
        })
        .eq('id', product.id)
        .select()
        .single();

    return CrmProductModel.fromJson(response);
  }

  /// Eliminar producto
  Future<void> deleteProduct(String id) async {
    await _client.from('crm_products').delete().eq('id', id);
  }

  /// Contar productos
  Future<int> countProducts() async {
    final response = await _client
        .from('crm_products')
        .select('id')
        .count(CountOption.exact);
    return response.count;
  }

  // =====================================================
  // LICENCIAS
  // =====================================================

  /// Obtener todas las licencias con joins
  Future<List<LicenseModel>> getLicenses() async {
    final response = await _client
        .from('licenses')
        .select('*, clients(*), crm_products(*)')
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => LicenseModel.fromJson(json))
        .toList();
  }

  /// Obtener licencias por estado
  Future<List<LicenseModel>> getLicensesByStatus(LicenseStatus status) async {
    final response = await _client
        .from('licenses')
        .select('*, clients(*), crm_products(*)')
        .eq('status', status.value)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => LicenseModel.fromJson(json))
        .toList();
  }

  /// Obtener licencias de un cliente
  Future<List<LicenseModel>> getLicensesByClient(String clientId) async {
    final response = await _client
        .from('licenses')
        .select('*, clients(*), crm_products(*)')
        .eq('client_id', clientId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => LicenseModel.fromJson(json))
        .toList();
  }

  /// Obtener licencia por ID
  Future<LicenseModel?> getLicenseById(String id) async {
    final response = await _client
        .from('licenses')
        .select('*, clients(*), crm_products(*)')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return LicenseModel.fromJson(response);
  }

  /// Crear licencia
  Future<LicenseModel> createLicense(LicenseModel license) async {
    final response = await _client
        .from('licenses')
        .insert(license.toInsertJson())
        .select('*, clients(*), crm_products(*)')
        .single();

    return LicenseModel.fromJson(response);
  }

  /// Actualizar licencia
  Future<LicenseModel> updateLicense(LicenseModel license) async {
    final response = await _client
        .from('licenses')
        .update({
          'client_id': license.clientId,
          'product_id': license.productId,
          'type': license.type.value,
          'start_date': license.startDate.toIso8601String().split('T')[0],
          'end_date': license.endDate?.toIso8601String().split('T')[0],
          'status': license.status.value,
        })
        .eq('id', license.id)
        .select('*, clients(*), crm_products(*)')
        .single();

    return LicenseModel.fromJson(response);
  }

  /// Eliminar licencia
  Future<void> deleteLicense(String id) async {
    await _client.from('licenses').delete().eq('id', id);
  }

  /// Contar licencias activas
  Future<int> countActiveLicenses() async {
    final response = await _client
        .from('licenses')
        .select('id')
        .eq('status', 'activa')
        .count(CountOption.exact);
    return response.count;
  }

  /// Contar todas las licencias
  Future<int> countLicenses() async {
    final response = await _client
        .from('licenses')
        .select('id')
        .count(CountOption.exact);
    return response.count;
  }

  /// Obtener estadísticas del dashboard
  Future<Map<String, int>> getDashboardStats() async {
    final clients = await countClients();
    final products = await countProducts();
    final activeLicenses = await countActiveLicenses();
    final totalLicenses = await countLicenses();

    return {
      'clients': clients,
      'products': products,
      'activeLicenses': activeLicenses,
      'totalLicenses': totalLicenses,
    };
  }
}
