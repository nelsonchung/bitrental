// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:admin_management/main.dart';

void main() {
  testWidgets('Check for GoogleMap widget', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(AdminManagementApp());

    // Verify that a GoogleMap widget is present.
    expect(find.byType(GoogleMap), findsOneWidget);
  });
}
