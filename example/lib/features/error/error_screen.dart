import 'package:example/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:star/star.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  static const routeName = RouteName('error');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              "Couldn't parse URL",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: FilledButton(
              onPressed: () {
                context.star.navigate(HomeScreen.routeName);
              },
              child: const Text('Go home'),
            ),
          ),
        ],
      ),
    );
  }
}
