import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:firebasetodo/main.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock Firebase Core
    MethodChannel('plugins.flutter.io/firebase_core')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'Firebase#initializeApp') {
        return [
          {
            'name': 'mock-app',
            'options': {
              'apiKey': 'mock_api_key',
              'appId': 'mock_app_id',
              'messagingSenderId': 'mock_sender_id',
              'projectId': 'mock_project_id',
            },
            'pluginConstants': {},
          }
        ];
      }
      return null;
    });
  });

  group('Firestore Calculator Widget Tests', () {
    testWidgets('App launches and displays correct title and structure', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyApp()));
      await tester.pumpAndSettle();

      expect(find.text("Vighnesh's Firestore Calculator (Exp 10)"), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('App displays the initial calculation output', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalculatorPage()));
      await tester.pumpAndSettle();

      // ✅ use the key instead of find.text('0')
      expect(find.byKey(const Key('displayText')), findsOneWidget);
      expect(find.text('0'), findsWidgets); // optional, shows both are present
    });
  });
}
