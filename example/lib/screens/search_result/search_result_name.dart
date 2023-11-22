import 'package:flutter/material.dart';
import 'package:flutter_stack_router/my_router.dart';

class SearchResultScreenData extends RouteValue {
  const SearchResultScreenData(this.query);

  final String query;
}

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({
    required this.data,
    super.key,
  });

  final SearchResultScreenData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.purple.shade200,
        child: Center(
          child: Text('Serch query: ${data.query}'),
        ),
      ),
    );
  }
}
