import 'package:flutter/material.dart';
import '../../../core/services/user_service.dart';
import '../screens/vendor_home_screen.dart';
import '../screens/buyer_marketplace_screen.dart';

/// Pantalla principal que redirige según el rol del usuario
class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: UserService.getRolUsuarioActual(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Cargando...'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final rol = snapshot.data ?? 'vendor';

        // Si es vendedor, mostrar VendorHomeScreen
        if (rol == 'vendor') {
          return const VendorHomeScreen();
        }

        // Si es comprador, mostrar BuyerMarketplaceScreen
        return const BuyerMarketplaceScreen();
      },
    );
  }
}
