import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';
import 'package:flutter_stack_router/stack_router.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const routeValue =DestinationName('search');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade200,
        child: const Center(
          child: Text('Search'),
        ),
      ),
    );
  }
}
