import 'package:example/features/home/widgets/usecase_banner.dart';
import 'package:example/features/utils/context_x.dart';
import 'package:example/features/utils/screen_sizes.dart';
import 'package:flutter/material.dart';
import 'package:snowflake_route/srs/value/route_name.dart';

const headerCaption = '''Declarative 
Type-safe
Codegen-free
Minimum boilerplate''';

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
                  height: 192,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/home/header.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            'Flutter Fractal',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: switch (context.width) {
                                > mediumWidth => 96,
                                > compactWidth => 64,
                                _ => 48,
                              },
                              fontWeight: FontWeight.w900,
                            ),
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
                    child: Column(
                      children: [
                        buildWrap(),
                      ],
                    ),
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
      final items = [
        Card(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: context.col.secondaryContainer, width: 2),
            borderRadius: BorderRadius.circular(32),
          ),
          child: const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text(
                headerCaption,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const UsecaseBanner(
          image: 'assets/home/typesafe.jpeg',
          header: 'Value-based navigation',
          caption: '''Pass type-safe parameters to the routes. 
No codegen and minimum boilerplate.''',
        ),
        const UsecaseBanner(
          image: 'assets/home/nested.jpeg',
          header: 'Nested routes',
          caption:
              'Can create nested routes, like one with bottom navigation bar.',
        ),
        const UsecaseBanner(
          image: 'assets/home/extensible.jpeg',
          header: 'Extensible',
          caption: 'You can extend built in classes for specialized use-cases.',
        ),
        const UsecaseBanner(
          image: 'assets/home/dialog.jpeg',
          header: 'Return value from a route',
          caption: '...',
        ),
        const UsecaseBanner(
            image: 'assets/home/guards.jpeg',
            header: 'Guards',
            caption: '''Redirect to login page if not logged in. 
Lets you subscribe to the context.'''),
      ];

      const oneItem = 350.0;
      final rowCount = cons.maxWidth ~/ oneItem;

      return Column(
        children: items
            .batch(rowCount)
            .map((e) => SizedBox(
                  height: 384,
                  child: Row(
                    children: e.map((e) => Expanded(child: e)).toList(),
                  ),
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
