import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import 'services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isOnboardingComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool completed = prefs.getBool('onboarding_complete') ?? false;
    // ignore: avoid_print
    print('Onboarding completed: $completed');
    return false; // Force the onboarding screen to display for testing
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'European Countries',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _isOnboardingComplete(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while checking status
          } else {
            if (snapshot.data == true) {
              return HomeScreen(apiClient: ApiClient(Dio()));
            } else {
              return const OnboardingScreen();
            }
          }
        },
      ),
    );
  }
}
