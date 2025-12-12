import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/theme/app_theme.dart';
import 'shared/constants/app_constants.dart';
import 'shared/providers/data_providers.dart';
import 'shared/providers/crm_provider.dart';
import 'features/splash/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/main_home_screen.dart';
import 'features/home/screens/vendor_home_screen.dart';
import 'features/productos/screens/crear_producto_screen.dart';
import 'features/ventas/screens/crear_venta_screen.dart';
import 'features/gastos/screens/crear_gasto_screen.dart';
// CRM Screens
import 'features/crm/screens/crm_login_screen.dart';
import 'features/crm/screens/crm_register_screen.dart';
import 'features/crm/screens/crm_dashboard_screen.dart';
import 'features/crm/screens/crm_client_form_screen.dart';
import 'features/crm/screens/crm_client_detail_screen.dart';
import 'features/crm/screens/crm_product_form_screen.dart';
import 'features/crm/screens/crm_license_form_screen.dart';
import 'features/crm/screens/module_selector_screen.dart';

/// Widget raiz de la aplicacion MarketMove
class MarketMoveApp extends StatelessWidget {
  const MarketMoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductosProvider()),
        ChangeNotifierProvider(create: (_) => VentasProvider()),
        ChangeNotifierProvider(create: (_) => GastosProvider()),
        ChangeNotifierProvider(create: (_) => ResumenProvider()),
        ChangeNotifierProvider(create: (_) => CrmProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        // Empezamos con el splash screen
        home: const SplashScreen(),
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const MainHomeScreen(),
          '/vendor-home': (context) => const VendorHomeScreen(),
          '/crear-producto': (context) => const CrearProductoScreen(),
          '/crear-venta': (context) => const CrearVentaScreen(),
          '/crear-gasto': (context) => const CrearGastoScreen(),
          // CRM Routes
          '/crm-login': (context) => const CrmLoginScreen(),
          '/crm-register': (context) => const CrmRegisterScreen(),
          '/crm-dashboard': (context) => const CrmDashboardScreen(),
          '/crm-client-form': (context) => const CrmClientFormScreen(),
          '/crm-client-detail': (context) => const CrmClientDetailScreen(),
          '/crm-product-form': (context) => const CrmProductFormScreen(),
          '/crm-license-form': (context) => const CrmLicenseFormScreen(),
          '/module-selector': (context) => const ModuleSelectorScreen(),
        },
      ),
    );
  }
}
