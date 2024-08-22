import 'package:flutter_test/flutter_test.dart';
import 'package:european_countries/models/country_model.dart';

void main() {
  group('CountryModel', () {
    test('fromJson should correctly parse valid JSON', () {
      final json = {
        "name": {"common": "France", "official": "French Republic"},
        "capital": ["Paris"],
        "flags": {
          "png": "https://flagcdn.com/w320/fr.png",
          "svg": "https://flagcdn.com/fr.svg"
        },
        "region": "Europe",
        "languages": {"fra": "French"},
        "population": 67081000
      };

      final country = CountryModel.fromJson(json);

      expect(country.name.common, 'France');
      expect(country.name.official, 'French Republic');
      expect(country.capital.first, 'Paris');
      expect(country.flags.png, 'https://flagcdn.com/w320/fr.png');
      expect(country.region, 'Europe');
      expect(country.languages?['fra'],
          'French'); // Use ? to safely access languages
      expect(country.population, 67081000);
    });

    test('toJson should correctly convert to JSON', () {
      final country = CountryModel(
        name: Name(common: 'France', official: 'French Republic'),
        capital: ['Paris'],
        flags: Flags(
          png: 'https://flagcdn.com/w320/fr.png',
          svg: 'https://flagcdn.com/fr.svg',
        ),
        region: 'Europe',
        languages: {'fra': 'French'},
        population: 67081000,
      );

      final json = country.toJson();

      final expectedJson = {
        'name': {
          'common': 'France',
          'official': 'French Republic',
        },
        'capital': ['Paris'],
        'flags': {
          'png': 'https://flagcdn.com/w320/fr.png',
          'svg': 'https://flagcdn.com/fr.svg',
          'alt': null,
        },
        'region': 'Europe',
        'languages': {'fra': 'French'},
        'population': 67081000,
      };

      // Compare the entire JSON structure
      expect(json, expectedJson);
    });
  });
}
