import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'detail_screen.dart';
import 'models/country_model.dart';
import 'services/api_client.dart';

class HomeScreen extends StatefulWidget {
  final ApiClient apiClient;

  const HomeScreen({super.key, required this.apiClient});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<CountryModel>> _countriesFuture;
  String _errorMessage = '';
  String _sortCriteria = 'Name';
  String _instructionMessage = ''; // State variable for the instruction message

  @override
  void initState() {
    super.initState();
    _countriesFuture = _fetchCountries();
    _updateInstructionMessage(); // Initialize the message based on default sort criteria
  }

  // Method to update the instruction message based on the selected sorting criteria
  void _updateInstructionMessage() {
    setState(() {
      switch (_sortCriteria) {
        case 'Name':
          _instructionMessage = 'Sorted alphabetically by name.';
          break;
        case 'Population':
          _instructionMessage = 'Sorted by population, highest to lowest.';
          break;
        case 'Capital':
          _instructionMessage = 'Sorted alphabetically by capital city.';
          break;
        default:
          _instructionMessage = '';
      }
    });
  }

  Future<List<CountryModel>> _fetchCountries() async {
    try {
      List<CountryModel> countries =
          await widget.apiClient.getEuropeanCountries();
      if (countries.isEmpty) {
        setState(() {
          _errorMessage = 'No countries found.';
        });
        return [];
      } else {
        setState(() {
          _errorMessage = '';
        });
        return countries;
      }
    } on DioException catch (dioError) {
      setState(() {
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.receiveTimeout:
            _errorMessage = 'The request timed out. Please try again later.';
            break;
          case DioExceptionType.badResponse:
            if (dioError.response?.statusCode == 500) {
              _errorMessage = 'Server error. Please try again later.';
            } else if (dioError.response?.statusCode == 404) {
              _errorMessage = 'Resource not found. Please try again.';
            } else if (dioError.response?.statusCode == 401) {
              _errorMessage =
                  'Unauthorized access. Please check your credentials.';
            } else {
              _errorMessage =
                  'Received invalid status code: ${dioError.response?.statusCode}';
            }
            break;
          case DioExceptionType.cancel:
            _errorMessage = 'Request to the server was cancelled.';
            break;
          case DioExceptionType.connectionError:
            _errorMessage =
                'No internet connection. Please check your network and try again.';
            break;
          default:
            _errorMessage =
                'Unexpected error occurred. Please try again later.';
        }
      });
      return [];
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
      });
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('European Countries'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sort by:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: _sortCriteria,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _sortCriteria = newValue;
                          });
                          _updateInstructionMessage(); // Update the message when sort criteria changes
                        }
                      },
                      items: <String>['Name', 'Population', 'Capital']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              _instructionMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Expanded(
            child: _errorMessage.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : FutureBuilder<List<CountryModel>>(
                    future: _countriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No countries found.'));
                      } else {
                        _sortCountries(snapshot.data!);

                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final country = snapshot.data![index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    country.flags.png,
                                    width: 50,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  country.name.common,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Capital: ${country.capital.join(', ')}',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(country: country),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _sortCountries(List<CountryModel> countries) {
    switch (_sortCriteria) {
      case 'Name':
        countries.sort((a, b) => a.name.common.compareTo(b.name.common));
        break;
      case 'Population':
        countries.sort((a, b) => a.population.compareTo(b.population));
        break;
      case 'Capital':
        countries.sort((a, b) => a.capital.first.compareTo(b.capital.first));
        break;
    }
  }
}
