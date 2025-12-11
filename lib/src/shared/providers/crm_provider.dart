import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../models/client_model.dart';
import '../models/crm_product_model.dart';
import '../models/license_model.dart';
import '../services/crm_service.dart';

/// Provider para gestionar el estado del CRM
class CrmProvider extends ChangeNotifier {
  final CrmService _service = CrmService();

  // Estado del usuario
  ProfileModel? _currentProfile;
  bool _isLoading = false;
  String? _error;

  // Datos del CRM
  List<ClientModel> _clients = [];
  List<CrmProductModel> _products = [];
  List<LicenseModel> _licenses = [];
  Map<String, int> _stats = {};

  // Getters
  ProfileModel? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAdmin => _currentProfile?.isAdmin ?? false;
  bool get isAuthenticated => _service.isAuthenticated;

  List<ClientModel> get clients => _clients;
  List<CrmProductModel> get products => _products;
  List<LicenseModel> get licenses => _licenses;
  Map<String, int> get stats => _stats;

  // Filtros de licencias
  List<LicenseModel> get activeLicenses =>
      _licenses.where((l) => l.status == LicenseStatus.activa).toList();

  List<LicenseModel> get inactiveLicenses =>
      _licenses.where((l) => l.status == LicenseStatus.inactiva).toList();

  List<LicenseModel> get pendingPaymentLicenses =>
      _licenses.where((l) => l.status == LicenseStatus.pendientePago).toList();

  List<LicenseModel> get expiredLicenses =>
      _licenses.where((l) => l.isExpired).toList();

  // =====================================================
  // AUTENTICACIÓN
  // =====================================================

  /// Iniciar sesión
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _service.signIn(email, password);
      await loadCurrentProfile();
      return true;
    } catch (e) {
      _setError('Error al iniciar sesión: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Registrar nuevo usuario
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    String role = 'staff',
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _service.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
      );
      return true;
    } catch (e) {
      _setError('Error al registrar: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _service.signOut();
    _currentProfile = null;
    _clients = [];
    _products = [];
    _licenses = [];
    _stats = {};
    notifyListeners();
  }

  /// Cargar perfil del usuario actual
  Future<void> loadCurrentProfile() async {
    try {
      _currentProfile = await _service.getCurrentProfile();
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar perfil: ${e.toString()}');
    }
  }

  // =====================================================
  // DASHBOARD
  // =====================================================

  /// Cargar estadísticas del dashboard
  Future<void> loadDashboardStats() async {
    _setLoading(true);
    try {
      _stats = await _service.getDashboardStats();
    } catch (e) {
      _setError('Error al cargar estadísticas: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Cargar todos los datos del CRM
  Future<void> loadAllData() async {
    _setLoading(true);
    try {
      await Future.wait([
        loadClients(),
        loadProducts(),
        loadLicenses(),
        loadDashboardStats(),
      ]);
    } catch (e) {
      _setError('Error al cargar datos: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // =====================================================
  // CLIENTES
  // =====================================================

  /// Cargar clientes
  Future<void> loadClients() async {
    try {
      _clients = await _service.getClients();
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar clientes: ${e.toString()}');
    }
  }

  /// Obtener cliente por ID
  ClientModel? getClientById(String id) {
    try {
      return _clients.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Crear cliente
  Future<bool> createClient(ClientModel client) async {
    if (!isAdmin) {
      _setError('Solo los administradores pueden crear clientes');
      return false;
    }

    _setLoading(true);
    try {
      final newClient = client.copyWith(createdBy: _currentProfile?.id);
      final created = await _service.createClient(newClient);
      _clients.insert(0, created);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al crear cliente: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Actualizar cliente
  Future<bool> updateClient(ClientModel client) async {
    if (!isAdmin) {
      _setError('Solo los administradores pueden editar clientes');
      return false;
    }

    _setLoading(true);
    try {
      final updated = await _service.updateClient(client);
      final index = _clients.indexWhere((c) => c.id == client.id);
      if (index != -1) {
        _clients[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Error al actualizar cliente: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Eliminar cliente
  Future<bool> deleteClient(String id) async {
    if (!isAdmin) {
      _setError('Solo los administradores pueden eliminar clientes');
      return false;
    }

    _setLoading(true);
    try {
      await _service.deleteClient(id);
      _clients.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al eliminar cliente: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // =====================================================
  // PRODUCTOS
  // =====================================================

  /// Cargar productos
  Future<void> loadProducts() async {
    try {
      _products = await _service.getProducts();
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar productos: ${e.toString()}');
    }
  }

  /// Obtener producto por ID
  CrmProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Crear producto
  Future<bool> createProduct(CrmProductModel product) async {
    if (!isAdmin) {
      _setError('Solo los administradores pueden crear productos');
      return false;
    }

    _setLoading(true);
    try {
      final created = await _service.createProduct(product);
      _products.insert(0, created);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al crear producto: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Actualizar producto
  Future<bool> updateProduct(CrmProductModel product) async {
    if (!isAdmin) {
      _setError('Solo los administradores pueden editar productos');
      return false;
    }

    _setLoading(true);
    try {
      final updated = await _service.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Error al actualizar producto: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Eliminar producto
  Future<bool> deleteProduct(String id) async {
    if (!isAdmin) {
      _setError('Solo los administradores pueden eliminar productos');
      return false;
    }

    _setLoading(true);
    try {
      await _service.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al eliminar producto: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // =====================================================
  // LICENCIAS
  // =====================================================

  /// Cargar licencias
  Future<void> loadLicenses() async {
    try {
      _licenses = await _service.getLicenses();
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar licencias: ${e.toString()}');
    }
  }

  /// Obtener licencias de un cliente
  List<LicenseModel> getLicensesByClient(String clientId) {
    return _licenses.where((l) => l.clientId == clientId).toList();
  }

  /// Crear licencia
  Future<bool> createLicense(LicenseModel license) async {
    if (!isAdmin) {
      _setError('Solo los administradores pueden crear licencias');
      return false;
    }

    _setLoading(true);
    try {
      final created = await _service.createLicense(license);
      _licenses.insert(0, created);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al crear licencia: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Actualizar licencia
  Future<bool> updateLicense(LicenseModel license) async {
    if (!isAdmin) {
      _setError('Solo los administradores pueden editar licencias');
      return false;
    }

    _setLoading(true);
    try {
      final updated = await _service.updateLicense(license);
      final index = _licenses.indexWhere((l) => l.id == license.id);
      if (index != -1) {
        _licenses[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Error al actualizar licencia: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Eliminar licencia
  Future<bool> deleteLicense(String id) async {
    if (!isAdmin) {
      _setError('Solo los administradores pueden eliminar licencias');
      return false;
    }

    _setLoading(true);
    try {
      await _service.deleteLicense(id);
      _licenses.removeWhere((l) => l.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al eliminar licencia: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // =====================================================
  // UTILIDADES INTERNAS
  // =====================================================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
