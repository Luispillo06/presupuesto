// Test básico de la aplicación MarketMove
//
// Para realizar interacciones con widgets en el test, usa WidgetTester
// del paquete flutter_test.

import 'package:flutter_test/flutter_test.dart';

import 'package:marketmove_app/src/app.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MarketMoveApp());

    // Verify that the login screen is displayed
    expect(find.text('MarketMove'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });
}
