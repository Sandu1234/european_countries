import 'package:flutter/material.dart';
import 'models/country_model.dart';

class DetailScreen extends StatelessWidget {
  final CountryModel country;

  const DetailScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(country.name.common ?? 'Unknown Country'), // Handle null case
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    country.flags.png ?? '', // Handle null case
                    width: 200,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              country.name.official ??
                  'Unknown Official Name', // Handle null case
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Capital:',
                country.capital?.join(', ') ?? 'Unknown'), // Handle null case
            _buildDetailRow('Population:', country.population.toString()),
            _buildDetailRow(
                'Region:', country.region ?? 'Unknown'), // Handle null case
            _buildDetailRow(
                'Languages:',
                country.languages?.values.join(', ') ??
                    'Unknown'), // Handle null case
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
