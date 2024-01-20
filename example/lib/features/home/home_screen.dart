import 'package:example/features/home/widgets/header.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeHeader(),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: expandedWidth),
                child: Padding(
                  padding: const EdgeInsets.all(8),
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
            .map((e) => IntrinsicHeight(
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
