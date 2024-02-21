import 'package:flutter/material.dart';
import 'package:hyper_router/hyper_router.dart';


class InboxSubrouteScreen extends StatelessWidget {
  const InboxSubrouteScreen({super.key});

  static const routeName = RouteName('subroute');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            'Subroute',
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
