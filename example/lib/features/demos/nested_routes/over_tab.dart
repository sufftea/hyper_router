
import 'package:flutter/material.dart';
import 'package:star/star.dart';

class CoveringTabScreen extends StatelessWidget {
  const CoveringTabScreen({super.key});

  static const routeName = RouteName('covering-tab');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            context.star.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'This tab is displayed over the tab shell',
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
