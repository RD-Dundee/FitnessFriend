import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_friend/screens/home.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home screen shows key elements', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: homeScreen()));

    expect(find.text('Saved Meals'), findsOneWidget);
    expect(find.text('Carbs'), findsOneWidget);
    expect(find.text('Protein'), findsOneWidget);
    expect(find.text('Fat'), findsOneWidget);
  });
}
