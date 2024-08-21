import 'package:european_countries/models/country_model.dart';
import 'package:european_countries/services/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'home_screen_test.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;

  setUp(() {
    // Initialize the mock instance before each test
    mockApiClient = MockApiClient();
  });

  test('getEuropeanCountries returns a list of countries', () async {
    // Arrange
    final countries = [
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
    ];

    // Set up the mock to return a Future with countries list
    when(mockApiClient.getEuropeanCountries())
        .thenAnswer((_) async => countries);

    // Act
    final result = await mockApiClient.getEuropeanCountries();

    // Assert
    expect(result, isA<List<CountryModel>>());
    expect(result.first.name.common, 'France');
  });

  test('getEuropeanCountries handles DioException', () async {
    // Arrange
    when(mockApiClient.getEuropeanCountries()).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Error',
        type: DioExceptionType.connectionTimeout, // Use an appropriate type
      ),
    );

    // Act & Assert
    expect(mockApiClient.getEuropeanCountries(), throwsA(isA<DioException>()));
  });

  test('getEuropeanCountries returns empty list when no countries found',
      () async {
    // Arrange
    when(mockApiClient.getEuropeanCountries()).thenAnswer((_) async => []);

    // Act
    final result = await mockApiClient.getEuropeanCountries();

    // Assert
    expect(result, isA<List<CountryModel>>());
    expect(result, isEmpty);
  });
}
