import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notification_push_challenge/main.dart';

void main() {
  testWidgets('muestra la pantalla principal de notificaciones', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Notificaciones Push'), findsWidgets);
    expect(
      find.text('Configuración de entorno para notificaciones push'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.notifications), findsOneWidget);
  });
}
