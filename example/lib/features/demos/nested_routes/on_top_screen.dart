import 'package:flutter/material.dart';
import 'package:snowflake_route/snowflake_route.dart';

class OverScreen extends StatelessWidget {
  const OverScreen({super.key});

  static const routeName = RouteName('over');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            context.flake.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'This screen is displayed over the tab shell',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
