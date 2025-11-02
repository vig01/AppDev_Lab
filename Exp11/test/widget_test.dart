import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restapi/main.dart';

void main() {
  group('Weather App Widget Tests', () {
    testWidgets('Displays loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(const WeatherApp());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays city input field', (WidgetTester tester) async {
      await tester.pumpWidget(const WeatherApp());
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
