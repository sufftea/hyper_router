import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const routeName = DestinationName('profile');

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