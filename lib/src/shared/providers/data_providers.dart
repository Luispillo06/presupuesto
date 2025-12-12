import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';

/// ChangeNotifier para gestionar Productos
/// Captura excepciones del DataService y el programa continúa funcionando
class ProductosProvider extends ChangeNotifier {
  final DataService _dataService = DataService();

  List<Producto> _productos = [];
  bool _isLoading = false;

  List<Producto> get productos => _productos;
  bool get isLoading => _isLoading;

  ProductosProvider() {
    loadProductos();
  }

  Future<void> loadProductos() async {
    _isLoading = true;
    notifyListeners();

    _productos = await _dataService.getProductos();
    _isLoading = false;
    notifyListeners();
  }

  /// Cargar solo productos con stock disponible (para compradores)
  Future<void> loadProductosDisponibles() async {
    _isLoading = true;
    notifyListeners();

    _productos = await _dataService.getProductos();
    // Filtrar solo productos con stock > 0
    _productos = _productos.where((p) => p.stock > 0).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addProducto(Producto producto) async {
    final result = await _dataService.createProducto(producto);
    if (result != null) {
      await loadProductos();
      return true;
    }
    return false;
  }

  Future<bool> updateProducto(Producto producto) async {
    final result = await _dataService.updateProducto(producto);
    if (result != null) {
      await loadProductos();
      return true;
    }
    return false;
  }

  Future<bool> deleteProducto(int id) async {
    final result = await _dataService.deleteProducto(id);
    if (result) {
      await loadProductos();
      return true;
    }
    return false;
  }
}

/// ChangeNotifier para gestionar Ventas
/// Captura excepciones del DataService y el programa continúa funcionando
class VentasProvider extends ChangeNotifier {
  final DataService _dataService = DataService();

  List<Venta> _ventas = [];
  bool _isLoading = false;

  List<Venta> get ventas => _ventas;
  bool get isLoading => _isLoading;

  VentasProvider() {
    loadVentas();
  }

  Future<void> loadVentas() async {
    _isLoading = true;
    notifyListeners();

    _ventas = await _dataService.getVentas();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addVenta(Venta venta) async {
    final result = await _dataService.createVenta(venta);
    if (result != null) {
      await loadVentas();
      return true;
    }
    return false;
  }

  Future<bool> updateVenta(Venta venta) async {
    final result = await _dataService.updateVenta(venta);
    if (result != null) {
      await loadVentas();
      return true;
    }
    return false;
  }

  Future<bool> deleteVenta(int id) async {
    final result = await _dataService.deleteVenta(id);
    if (result) {
      await loadVentas();
      return true;
    }
    return false;
  }
}

/// ChangeNotifier para gestionar Gastos
/// Captura excepciones del DataService y el programa continúa funcionando
class GastosProvider extends ChangeNotifier {
  final DataService _dataService = DataService();

  List<Gasto> _gastos = [];
  bool _isLoading = false;

  List<Gasto> get gastos => _gastos;
  bool get isLoading => _isLoading;

  GastosProvider() {
    loadGastos();
  }

  Future<void> loadGastos() async {
    _isLoading = true;
    notifyListeners();

    _gastos = await _dataService.getGastos();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addGasto(Gasto gasto) async {
    final result = await _dataService.createGasto(gasto);
    if (result != null) {
      await loadGastos();
      return true;
    }
    return false;
  }

  Future<bool> updateGasto(Gasto gasto) async {
    final result = await _dataService.updateGasto(gasto);
    if (result != null) {
      await loadGastos();
      return true;
    }
    return false;
  }

  Future<bool> deleteGasto(int id) async {
    final result = await _dataService.deleteGasto(id);
    if (result) {
      await loadGastos();
      return true;
    }
    return false;
  }
}

/// ChangeNotifier para gestionar Resumen
/// Captura excepciones del DataService y el programa continúa funcionando
class ResumenProvider extends ChangeNotifier {
  final DataService _dataService = DataService();

  double _totalVentas = 0;
  double _totalGastos = 0;
  double _balance = 0;
  int _totalProductos = 0;
  int _productosStockBajo = 0;
  bool _isLoading = false;

  double get totalVentas => _totalVentas;
  double get totalGastos => _totalGastos;
  double get balance => _balance;
  int get totalProductos => _totalProductos;
  int get productosStockBajo => _productosStockBajo;
  List<Map<String, dynamic>> get recentTransactions => _recentTransactions;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _recentTransactions = [];

  ResumenProvider() {
    loadResumen();
  }

  Future<void> loadResumen() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Obtener datos de ventas y gastos del día
      _totalVentas = await _dataService.getTotalVentasDelDia();
      _totalGastos = await _dataService.getTotalGastosDelDia();
      _balance = _totalVentas - _totalGastos;
      _totalProductos = await _dataService.getTotalProductos();
      _productosStockBajo = await _dataService.getTotalProductosStockBajo();

      // Cargar transacciones recientes
      final ventas = await _dataService.getVentas();
      final gastos = await _dataService.getGastos();

      final allTransactions = <Map<String, dynamic>>[];

      for (var v in ventas) {
        allTransactions.add({
          'type': 'venta',
          'title': v.cliente,
          'amount': v.monto,
          'date': v.fecha,
          'icon': Icons.trending_up,
          'color': AppTheme.successColor,
        });
      }

      for (var g in gastos) {
        allTransactions.add({
          'type': 'gasto',
          'title': g.concepto,
          'amount': g.monto,
          'date': g.fecha,
          'icon': Icons.trending_down,
          'color': AppTheme.errorColor,
        });
      }

      // Ordenar por fecha descendente
      allTransactions.sort(
        (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
      );

      _recentTransactions = allTransactions.take(10).toList();
    } catch (e) {
      debugPrint('Error loading resumen: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
