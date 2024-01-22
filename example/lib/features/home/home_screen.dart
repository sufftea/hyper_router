import 'package:example/features/demos/dialog/dialog_examples_screen.dart';
import 'package:example/features/demos/guard/authwalled_screen.dart';
import 'package:example/features/demos/nested_routes/inbox_screen.dart';
import 'package:example/features/demos/value_based/product_list/product_list_screen.dart';
import 'package:example/features/home/widgets/header.dart';
import 'package:example/features/home/widgets/usecase_banner.dart';
import 'package:example/features/widgets/limit_width.dart';
import 'package:flutter/material.dart';
import 'package:snowflake_route/snowflake_route.dart';


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
          onPressed: () {
            context.flake.navigate(InboxScreen.routeName);
          },
          image: 'assets/home/nested.jpeg',
          title: 'Nested routes',
          caption: 'A screen with a navigation bar',
        ),
        UsecaseBanner(
          onPressed: () async {
            context.flake.navigate(DialogExamplesScreen.routeName);
          },
          image: 'assets/home/dialog.jpeg',
          title: 'Return value from a route',
          caption: 'Show input dialog and return the value',
        ),
        UsecaseBanner(
          onPressed: () {
            context.flake.navigate(AuthwalledScreen.routeName);
          },
          image: 'assets/home/guards.jpeg',
          title: 'Guards',
          caption: '''Redirect to the login page if not logged in. 
Lets you subscribe to the context.''',
        ),
        UsecaseBanner(
          onPressed: () {},
          image: 'assets/home/extensible.jpeg',
          title: 'Custom routes',
          caption: 'You can extend built in classes for specialized use-cases.',
        ),
      ];

      const oneItem = 350.0;
      final rowCount = switch (cons.maxWidth ~/ oneItem) {
        < 1 => 1,
        final count => count,
      };

      return Column(
        children: items
            .batch(rowCount)
            .map(
              (e) => IntrinsicHeight(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 128),
                  child: Row(
                    children: e.map((e) => Expanded(child: e)).toList(),
                  ),
                ),
              ),
            )
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
