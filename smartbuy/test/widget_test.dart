// This is a basic Flutter widget test for SmartBuy app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:smartbuy/main.dart';

void main() {
  // Initialize GetStorage for testing
  setUpAll(() async {
    await GetStorage.init();
  });

  testWidgets('SmartBuy app initializes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartBuyApp());
    await tester.pumpAndSettle();

    // Verify that the splash screen or initial route loads
    // The app should display some content
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
