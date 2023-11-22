import 'package:flutter/material.dart';
import 'package:tea_router/tea_router.dart';

class RandomScreen extends StatelessWidget {
  const RandomScreen({super.key});

  static const routeValue = RouteName('random');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green.shade200,
        child: const Center(
          child: Text('something random'),
        ),
      ),
    );
  }
}
