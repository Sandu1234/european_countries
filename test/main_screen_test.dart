import 'package:european_countries/main.dart';
import 'package:european_countries/home_screen.dart';
import 'package:european_countries/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyApp shows OnboardingScreen if onboarding is not complete',
      (WidgetTester tester) async {
    // Arrange: Mock shared preferences to indicate onboarding is not complete
    SharedPreferences.setMockInitialValues({'onboarding_complete': false});

    // Act: Pump the widget
    await tester.pumpWidget(const MyApp());

    // Wait for the FutureBuilder to complete and UI to settle
    await tester.pumpAndSettle();

    // Assert: Check that OnboardingScreen is displayed
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });

  testWidgets('MyApp shows HomeScreen if onboarding is complete',
      (WidgetTester tester) async {
    // Arrange: Mock shared preferences to indicate onboarding is complete
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});

    // Act: Pump the widget
    await tester.pumpWidget(const MyApp());

    // Wait for the FutureBuilder to complete and UI to settle
    await tester.pumpAndSettle();

    // Assert: Check that HomeScreen is displayed
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
