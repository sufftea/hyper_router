import 'package:flutter/material.dart';
import 'package:tree_router/tree_router.dart';

class OneScreen extends StatelessWidget {
  const OneScreen({super.key});

  static const routeName = RouteName('one');

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

class TwoScreen extends StatelessWidget {
  const TwoScreen({super.key});

  static const routeName = RouteName('two');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.pink.shade200,
        child: const Center(
          child: Text('Two'),
        ),
      ),
    );
  }
}

class ThreeScreen extends StatelessWidget {
  const ThreeScreen({super.key});

  static const routeName = RouteName('Three');

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
