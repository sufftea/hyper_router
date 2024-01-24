import 'package:flutter/material.dart';
import 'package:star/star.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  static const routeName = RouteName('guide');

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'TODO: write a guide',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
