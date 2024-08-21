import 'package:flutter/material.dart';
import 'models/country_model.dart';

class DetailScreen extends StatelessWidget {
  final CountryModel
      country; // The selected country whose details will be displayed

  const DetailScreen(
      {super.key,
      required this.country}); // Constructor to initialize the selected country

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name
            .common), // Display the common name of the country in the AppBar
      ),
      body: SingleChildScrollView(
        // Allows scrolling if content overflows
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Align children to the start of the column
          children: [
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // Shadow color
                      blurRadius: 10.0, // Amount of blur
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10.0), // Rounded corners for the flag image
                  child: Image.network(
                    country.flags.png, // Display the country flag
                    width: 200,
                    height: 100,
                    fit: BoxFit
                        .cover, // Ensure the flag image covers the entire area
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24), // Add space between flag and details
            Text(
              country.name.official, // Display the official name of the country
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
                height:
                    16), // Add space between the official name and the first detail row
            // Display various details about the country
            _buildDetailRow('Capital:', country.capital.join(', ')),
            _buildDetailRow('Population:', country.population.toString()),
            _buildDetailRow('Region:', country.region),
            _buildDetailRow('Languages:', country.languages.values.join(', ')),
          ],
        ),
      ),
    );
  }

  // Helper method to build a detail row with a label and a value
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 8.0), // Add space between detail rows
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align items at the start of the row
        children: [
          Text(
            label, // Label for the detail (e.g., "Capital:")
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8), // Space between the label and the value
          Expanded(
            child: Text(
              value, // Value for the detail (e.g., the name of the capital)
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
