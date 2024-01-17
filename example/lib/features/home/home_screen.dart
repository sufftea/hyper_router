import 'package:example/features/home/widgets/usecase_banner.dart';
import 'package:example/features/utils/context_x.dart';
import 'package:example/features/utils/screen_sizes.dart';
import 'package:flutter/material.dart';
import 'package:fractal_router/fractal_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = RouteName('home');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/home/header.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Flutter Fractal',
                                style: TextStyle(
                                  fontSize: switch (context.width) {
                                    > mediumWidth => 96,
                                    > compactWidth => 64,
                                    _ => 48,
                                  },
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'The best router package in the world',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.loose(const Size.fromWidth(1300)),
                    child: buildWrap(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWrap() {
    return LayoutBuilder(builder: (context, cons) {
      const items = [
        UsecaseBanner(
          image: 'assets/home/declarative.jpeg',
          header: 'Declarative API',
          caption: 'Configure the route tree; navigate anywhere from anywhere',
        ),
        UsecaseBanner(
          image: 'assets/home/typesafe.jpeg',
          header: 'Value-based navigation',
          caption:
              'Pass type-safe parameters to the routes with minimal boilerplate and no codegen!',
        ),
        UsecaseBanner(
          image: 'assets/home/nested.jpeg',
          header: 'Nested routes',
          caption: 'Allows creating nested routes with bottom navigation bar',
        ),
        UsecaseBanner(
          image: 'assets/home/extensible.jpeg',
          header: 'Highly extensible',
          caption:
              'You can easily extend built in classes for specialized use-cases',
        ),
        UsecaseBanner(
          image: 'assets/home/dialog.jpeg',
          header: 'Return value from route',
          caption: 'TODO',
        ),
      ];

      const oneItem = 350.0;
      final rowCount = cons.maxWidth ~/ oneItem;

      return Column(
        children: items
            .batch(rowCount)
            .map((e) => Row(
                  children: e.map((e) => Expanded(child: e)).toList(),
                ))
            .toList(),
      );
    });
  }
}

extension _Batch<T> on List<T> {
  List<List<T>> batch(int batchSize) {
    return fold([<T>[]], (previousValue, element) {
      if (previousValue.last.length < batchSize) {
        previousValue.last.add(element);
      } else {
        previousValue.add([element]);
      }

      return previousValue;
    });
  }
}
