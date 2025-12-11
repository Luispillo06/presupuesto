import 'package:flutter/material.dart';
import '../../shared/models/compra_model.dart';
import '../../core/services/compras_service.dart';

/// Provider para gestionar compras conectado a Supabase
class ComprasProvider extends ChangeNotifier {
  final ComprasService _service = ComprasService();

  List<Compra> _compras = [];
  bool _isLoading = false;
  String? _error;

  List<Compra> get compras => _compras;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalCompras =>
      _compras.fold(0.0, (sum, c) => sum + c.precioTotal);

  /// Cargar compras del comprador actual desde BD
  Future<void> loadComprasDelComprador() async {
    _isLoading = true;
    notifyListeners();

    try {
      _compras = await _service.getComprasUsuario();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar compras recibidas por un vendedor desde BD
  Future<void> loadVentasDelVendedor() async {
    _isLoading = true;
    notifyListeners();

    try {
      _compras = await _service.getComprasRecibidas();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crear nueva compra en BD
  Future<bool> crearCompra({
    required String vendorId,
    required int productoId,
    required int cantidad,
    required double precioUnitario,
    required double precioTotal,
  }) async {
    try {
      final result = await _service.createCompra(
        vendorId: vendorId,
        productoId: productoId,
        cantidad: cantidad,
        precioUnitario: precioUnitario,
        precioTotal: precioTotal,
      );

      if (result != null) {
        _compras.insert(0, result);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Cancelar compra en BD
  Future<bool> cancelarCompra(int compraId) async {
    try {
      final success = await _service.cancelarCompra(compraId);

      if (success) {
        await loadComprasDelComprador();
      }

      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Confirmar compra en BD (vendedor)
  Future<bool> confirmarCompra(int compraId) async {
    try {
      final success = await _service.confirmarCompra(compraId);

      if (success) {
        await loadVentasDelVendedor();
      }

      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Obtener total de compras pendientes desde BD
  Future<int> getTotalPendientes() async {
    try {
      return await _service.getTotalComprasPendientes();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0;
    }
  }

  /// Limpiar estado
  void clear() {
    _compras = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
