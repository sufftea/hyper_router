import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeValue = DestinationName('home');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green.shade200,
        child: const Center(
          child: Text('Home'),
        ),
      ),
    );
  }
}
