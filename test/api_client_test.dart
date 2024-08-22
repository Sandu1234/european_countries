import 'package:dio/dio.dart';
import 'package:european_countries/services/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:european_countries/models/country_model.dart';
import 'api_client_test.mocks.dart';

// Generate the mock file
@GenerateMocks([Dio])
void main() {
  late ApiClient apiClient;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiClient = ApiClient(mockDio);

    // Stub the Dio options getter
    when(mockDio.options)
        .thenReturn(BaseOptions(baseUrl: 'https://restcountries.com/v3.1/'));
  });

  group('ApiClient', () {
    test('getEuropeanCountries returns a list of countries', () async {
      // Arrange
      final mockResponse = Response(
        data: [
          {
            "name": {"common": "France", "official": "French Republic"},
            "capital": ["Paris"],
            "flags": {
              "png": "https://flagcdn.com/w320/fr.png",
              "svg": "https://flagcdn.com/w320/fr.svg",
            },
            "region": "Europe",
            "languages": {"fra": "French"},
            "population": 67081000
          },
        ],
        requestOptions: RequestOptions(path: ''),
      );

      when(mockDio.fetch<List<dynamic>>(any))
          .thenAnswer((_) async => mockResponse);

      // Act
      final countries = await apiClient.getEuropeanCountries();

      // Assert
      expect(countries, isA<List<CountryModel>>());
      expect(countries.length, 1);
      expect(countries[0].name.common,
          "France"); // Updated to check the 'common' field of the 'Name' object
    });

    test('getEuropeanCountries throws an error on failure', () async {
      // Arrange
      when(mockDio.fetch<List<dynamic>>(any)).thenThrow(DioError(
        requestOptions: RequestOptions(path: ''),
        error: 'Something went wrong',
      ));

      // Act & Assert
      expect(() async => await apiClient.getEuropeanCountries(),
          throwsA(isA<DioError>()));
    });
  });
}
