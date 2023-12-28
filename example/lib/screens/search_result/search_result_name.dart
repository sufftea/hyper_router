import 'package:example/screens/number_screens/number_screens.dart';
import 'package:flutter/material.dart';
import 'package:tree_router/tree_router.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Serch query: ${data.query}'),
            ElevatedButton(
              onPressed: () {
                TreeRouter.of(context).navigate(SomeScreen.routeName3);
              },
              child: const Text('open another screen'),
            ),
          ],
        ),
      ),
    );
  }
}
