import 'package:flutter/material.dart';
import 'package:tree_router/tree_router.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  static const route1 = RouteName('placeholder1');
  static const route2 = RouteName('placeholder2');
  static const route3 = RouteName('placeholder3');
  static const route4 = RouteName('placeholder4');
  static const route5 = RouteName('placeholder5');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('pop'),
            ),
          ),
        ],
      ),
    );
  }
}
