import 'package:flutter/material.dart';
import '../../core/services/resumen_service.dart';

/// Provider para el resumen/balance del vendedor
class ResumenProvider extends ChangeNotifier {
  final ResumenService _service = ResumenService();

  dynamic _resumen;
  bool _isLoading = false;
  String? _error;

  dynamic get resumen => _resumen;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalGanancias => _resumen?.totalGanancias ?? 0.0;
  double get totalGastos => _resumen?.totalGastos ?? 0.0;
  double get balanceNeto => _resumen?.balanceNeto ?? 0.0;
  int get totalVentas => _resumen?.totalVentas ?? 0;
  int get totalGastosRegistrados => _resumen?.totalGastosRegistrados ?? 0;

  Future<void> loadResumen() async {
    _isLoading = true;
    notifyListeners();

    try {
      _resumen = await _service.getResumenActual();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Escuchar cambios en tiempo real
  void watchResumen() {
    _service.getResumenStream().listen((data) {
      _resumen = data;
      notifyListeners();
    });
  }
}
