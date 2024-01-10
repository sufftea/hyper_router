import 'package:flutter/material.dart';
import 'package:fractal_router/fractal_router.dart';

class SomeScreen extends StatelessWidget {
  const SomeScreen({super.key});

  static const routeName1 = RouteName('1');
  static const routeName2 = RouteName('2');
  static const routeName3 = RouteName('3');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepOrange.shade200,
        child: const Center(
          child: Text('One'),
        ),
      ),
    );
  }
}

class PopMeScreen extends StatelessWidget {
  const PopMeScreen({super.key});

  static const routeName = RouteName('pop_screen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple.shade200,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('pop me'),
          ),
        ),
      ),
    );
  }
}
