import 'package:dio/dio.dart';
import 'package:european_countries/home_screen.dart';
import 'package:european_countries/models/country_model.dart';
import 'package:european_countries/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock class for ApiClient
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late List<CountryModel> countries;

  setUp(() {
    mockApiClient = MockApiClient();

    countries = [
      CountryModel(
        name: Name(common: 'France', official: 'French Republic'),
        capital: ['Paris'],
        flags: Flags(
          png: 'https://flagcdn.com/w320/fr.png',
          svg: 'https://flagcdn.com/fr.svg',
        ),
        region: 'Europe',
        languages: {'fra': 'French'},
        population: 67081000,
      ),
      CountryModel(
        name: Name(common: 'Germany', official: 'Federal Republic of Germany'),
        capital: ['Berlin'],
        flags: Flags(
          png: 'https://flagcdn.com/w320/de.png',
          svg: 'https://flagcdn.com/de.svg',
        ),
        region: 'Europe',
        languages: {'deu': 'German'},
        population: 83019200,
      ),
    ];
  });

  testWidgets('HomeScreen fetches and displays countries',
      (WidgetTester tester) async {
    // Arrange
    when(mockApiClient.getEuropeanCountries())
        .thenAnswer((_) => Future.value(countries));

    // Act
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(apiClient: mockApiClient),
    ));

    await tester.pumpAndSettle(); // Wait for the UI to settle

    // Assert
    expect(find.text('France'), findsOneWidget);
    expect(find.text('Paris'), findsOneWidget);
    expect(find.text('Germany'), findsOneWidget);
    expect(find.text('Berlin'), findsOneWidget);
  });

  testWidgets(
      'HomeScreen shows "No countries found" when no countries are returned',
      (WidgetTester tester) async {
    // Arrange
    when(mockApiClient.getEuropeanCountries())
        .thenAnswer((_) => Future.value([]));

    // Act
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(apiClient: mockApiClient),
    ));

    await tester.pumpAndSettle(); // Wait for the UI to settle

    // Assert
    expect(find.text('No countries found.'), findsOneWidget);
  });

  testWidgets('HomeScreen shows an error message when an error occurs',
      (WidgetTester tester) async {
    // Arrange
    when(mockApiClient.getEuropeanCountries()).thenThrow(DioException(
      requestOptions: RequestOptions(path: '/'),
      type: DioExceptionType.connectionError,
    ));

    // Act
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(apiClient: mockApiClient),
    ));

    await tester.pumpAndSettle(); // Wait for the UI to settle

    // Assert
    expect(
        find.text(
            'No internet connection. Please check your network and try again.'),
        findsOneWidget);
  });

  testWidgets('HomeScreen sorts countries by name',
      (WidgetTester tester) async {
    // Arrange
    when(mockApiClient.getEuropeanCountries())
        .thenAnswer((_) => Future.value(countries));

    // Act
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(apiClient: mockApiClient),
    ));

    await tester.pumpAndSettle(); // Wait for the UI to settle

    // Assert that countries are sorted by name
    final franceFinder = find.text('France');
    final germanyFinder = find.text('Germany');

    expect(
        tester.getTopLeft(franceFinder).dy <
            tester.getTopLeft(germanyFinder).dy,
        isTrue);
  });

  testWidgets(
      'HomeScreen sorts countries by population when selected in the dropdown',
      (WidgetTester tester) async {
    // Arrange
    when(mockApiClient.getEuropeanCountries())
        .thenAnswer((_) => Future.value(countries));

    // Act
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(apiClient: mockApiClient),
    ));

    await tester.pumpAndSettle(); // Wait for the UI to settle

    // Select 'Population' from the dropdown menu
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Population').last);
    await tester.pumpAndSettle();

    // Assert that countries are sorted by population (Germany should come first)
    final germanyFinder = find.text('Germany');
    final franceFinder = find.text('France');

    expect(
        tester.getTopLeft(germanyFinder).dy <
            tester.getTopLeft(franceFinder).dy,
        isTrue);
  });

  testWidgets('HomeScreen navigates to DetailScreen when a country is tapped',
      (WidgetTester tester) async {
    // Arrange
    when(mockApiClient.getEuropeanCountries())
        .thenAnswer((_) => Future.value(countries));

    // Act
    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(apiClient: mockApiClient),
    ));

    await tester.pumpAndSettle(); // Wait for the UI to settle

    // Tap on the country list tile for 'France'
    await tester.tap(find.text('France'));
    await tester.pumpAndSettle();

    // Assert that DetailScreen is displayed with correct details
    expect(find.text('French Republic'), findsOneWidget);
    expect(find.text('Paris'), findsOneWidget);
    expect(find.text('67081000'), findsOneWidget);
    expect(find.text('Europe'), findsOneWidget);
    expect(find.text('French'), findsOneWidget);
  });
}
