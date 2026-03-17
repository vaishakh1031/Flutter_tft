import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tft_home/main.dart';

void main() {
  testWidgets('App loads TFT Dashboard smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our key UI elements from the TFT dashboard are present
    expect(find.text('THIS RIDE'), findsOneWidget);
    expect(find.text('ODO'), findsOneWidget);
    expect(find.text('RANGE'), findsOneWidget);
    expect(find.text('BATTERY'), findsOneWidget);
    expect(find.text('EFF'), findsOneWidget);
    expect(find.text('REGEN'), findsOneWidget);

    // Verify speed text is present
    expect(find.text('054'), findsOneWidget);
  });
}
