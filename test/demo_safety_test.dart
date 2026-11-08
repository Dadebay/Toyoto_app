import 'package:bmw_connect/data/mock_data.dart';
import 'package:bmw_connect/l10n/strings.dart';
import 'package:bmw_connect/screens/cart_screen.dart';
import 'package:bmw_connect/state/app_state.dart';
import 'package:bmw_connect/widgets/car_3d_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('checkout preview cannot clear the cart or claim an order', (
    tester,
  ) async {
    final state = AppState()..setLanguage(AppLanguage.en);
    state.addToCart(MockData.products.first);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(home: CartScreen()),
      ),
    );
    await tester.tap(find.text('Preview Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Demo checkout'), findsOneWidget);
    expect(
      find.text('No order was sent. Your cart remains in this demo.'),
      findsOneWidget,
    );
    expect(state.cartItemCount, 1);

    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();
    expect(state.cartItemCount, 1);
  });

  testWidgets('missing 3D model shows an explicit fallback', (tester) async {
    final state = AppState()..setLanguage(AppLanguage.en);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: Car3DViewer(modelAsset: 'assets/models/missing.glb'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('3D vehicle model unavailable'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
