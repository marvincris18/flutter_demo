import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App should have navigation rail with three destinations', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that we have the navigation rail destinations
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('AI Content'), findsOneWidget);

    // Verify that the home page is initially selected
    expect(find.text('Next'), findsOneWidget); // From the GeneratorPage
  });
}
