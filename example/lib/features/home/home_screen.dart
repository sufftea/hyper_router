import 'package:example/features/demos/value_based/product_list/product_list_screen.dart';
import 'package:example/features/home/widgets/header.dart';
import 'package:example/features/home/widgets/usecase_banner.dart';
import 'package:example/features/widgets/limit_width.dart';
import 'package:flutter/material.dart';
import 'package:snowflake_route/snowflake_route.dart';

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
            LimitWidth(
              child: Column(
                children: [
                  buildWrap(),
                ],
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
        UsecaseBanner(
          onPressed: () {
            context.flake.navigate(ProductListScreen.routeName);
          },
          image: 'assets/home/typesafe.jpeg',
          title: 'Value-based navigation',
          caption: 'Pass the Product object to the details screen',
        ),
        UsecaseBanner(
          onPressed: () {},
          image: 'assets/home/nested.jpeg',
          title: 'Nested routes',
          caption: 'A screen with a navigation bar',
        ),
        UsecaseBanner(
          onPressed: () {},
          image: 'assets/home/dialog.jpeg',
          title: 'Return value from a route',
          caption: 'Show input dialog and return the value',
        ),
        UsecaseBanner(
          onPressed: () {},
          image: 'assets/home/guards.jpeg',
          title: 'Guards',
          caption: '''Redirect to the login page if not logged in. 
Lets you subscribe to the context.''',
        ),
        UsecaseBanner(
          onPressed: () {},
          image: 'assets/home/extensible.jpeg',
          title: 'Extensible',
          caption: 'You can extend built in classes for specialized use-cases.',
        ),
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
