import 'package:flutter/material.dart';
import 'package:fractal_router/fractal_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const routeName = RouteName('profile');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow.shade200,
        child: const Center(
          child: Text('Profile'),
        ),
      ),
    );
  }
}