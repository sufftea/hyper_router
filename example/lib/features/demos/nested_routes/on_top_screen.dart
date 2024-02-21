import 'package:flutter/material.dart';
import 'package:hyper_router/hyper_router.dart';

class CoveringScreen extends StatelessWidget {
  const CoveringScreen({super.key});

  static const routeName = RouteName('covering-screen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            context.hyper.pop();
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
