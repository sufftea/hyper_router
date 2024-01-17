import 'package:example/navigation/router.dart';
import 'package:example/screens/search_result/search_result_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fractal_router/fractal_router.dart';

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
                  FractalRouter.of(context).navigate(SearchResultScreenData(
                    textController.text,
                  ));
                },
                child: const Text('search'),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return OutlinedButton(
                    onPressed: () {
                      final n = ref.watch(authStateProvider.notifier);
                      n.state = !n.state;
                    },
                    child: const Text('toggle auth'),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
