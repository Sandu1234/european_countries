import 'package:european_countries/onboarding_screen.dart';
import 'package:european_countries/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets(
      'OnboardingScreen completes onboarding and navigates to HomeScreen',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(
        {}); // Initialize SharedPreferences with empty values

    await tester.pumpWidget(const MaterialApp(
      home: OnboardingScreen(),
    ));

    // Tap the "Get Started" button
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle(); // Wait for navigation animation

    // Verify that the onboarding is complete
    SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('onboarding_complete'), true);

    // Verify that HomeScreen is shown
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
