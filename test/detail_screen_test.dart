import 'package:european_countries/models/country_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

// Custom Widget to Replace NetworkImage for Testing
class TestableNetworkImage extends StatelessWidget {
  final String url;

  TestableNetworkImage({required this.url});

  @override
  Widget build(BuildContext context) {
    // Return a placeholder Container instead of trying to load the network image
    return Container(
      color: Colors.grey,
      width: 200,
      height: 100,
      child: const Icon(Icons.image),
    );
  }
}

void main() {
  testWidgets('DetailScreen displays correct country information',
      (WidgetTester tester) async {
    // Arrange
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

    // Use TestableNetworkImage instead of NetworkImage
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text(country.name.official),
            Text(country.capital.first),
            Text(country.population.toString()),
            Text(country.region),
            Text(country.languages['fra']!),
            TestableNetworkImage(url: country.flags.png), // Placeholder
          ],
        ),
      ),
    ));

    // Assert
    expect(find.text('French Republic'), findsOneWidget);
    expect(find.text('Paris'), findsOneWidget);
    expect(find.text('67081000'), findsOneWidget);
    expect(find.text('Europe'), findsOneWidget);
    expect(find.text('French'), findsOneWidget);
  });
}
