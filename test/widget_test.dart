import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rideiq/main.dart';
 

void main() {
  testWidgets('Welcome screen shows headline and actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MyApp(),
      ),
    );

    expect(find.text('Turn every trip'), findsOneWidget);
    expect(find.text('into insight.'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });
}
