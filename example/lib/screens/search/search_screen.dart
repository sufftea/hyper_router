import 'package:example/screens/search_result/search_result_name.dart';
import 'package:flutter/material.dart';
import 'package:tea_router/tea_router.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  static const routeValue = RouteName('search');

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: textController,
              ),
              OutlinedButton(
                onPressed: () {
                  TeaRouter.of(context).navigate(SearchResultScreenData(
                    textController.text,
                  ));
                },
                child: const Text('search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
