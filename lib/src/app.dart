import 'package:flutter/material.dart';
import 'shared/theme/app_theme.dart';
import 'shared/constants/app_constants.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';

/// Widget raíz de la aplicación MarketMove
class MarketMoveApp extends StatelessWidget {
  const MarketMoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // Empezamos en login, pero para pruebas podemos ir directo a home
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

/// Pantalla de registro (placeholder)
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: const Center(child: Text('Pantalla de Registro')),
    );
  }
}
