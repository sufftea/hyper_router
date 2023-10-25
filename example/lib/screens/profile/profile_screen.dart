import 'package:flutter/material.dart';

class ProfileRouteData {
  const ProfileRouteData();
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('profile screen'),
      ),
    );
  }
}
