/// Constantes globales de la aplicación
class AppConstants {
  // Información de la app
  static const String appName = 'MarketMove';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Gestión para pequeños comercios';

  // Constantes de la empresa cliente
  static const String companyName = 'MarketMove S.L.';
  static const String companySector = 'Gestión de pequeños comercios';

  // Configuración de la API (Supabase - para configurar después)
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Constantes de navegación
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home';
  static const String routeVentas = '/ventas';
  static const String routeGastos = '/gastos';
  static const String routeProductos = '/productos';
  static const String routeResumen = '/resumen';

  // Constantes de validación
  static const int minPasswordLength = 6;
  static const int maxProductNameLength = 100;
  static const double minPrice = 0.01;

  // Mensajes comunes
  static const String msgLoading = 'Cargando...';
  static const String msgError = 'Ha ocurrido un error';
  static const String msgSuccess = 'Operación exitosa';
  static const String msgNoData = 'No hay datos disponibles';

  // Prevent instantiation
  AppConstants._();
}
