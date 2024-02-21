import 'package:flutter/material.dart';
import 'package:hyper_router/hyper_router.dart';


class InsideScreen extends StatelessWidget {
  const InsideScreen({super.key});

  static const routeName = RouteName('insides');

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "TODO: write about package's internal structure",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
