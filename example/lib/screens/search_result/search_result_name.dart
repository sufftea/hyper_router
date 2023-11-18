import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';

class SearchResultScreenData extends DestinationValue {
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
