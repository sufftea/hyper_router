import 'package:example/features/demos/custom_route/email_list_screen.dart';
import 'package:example/features/demos/dialog/dialog_examples_screen.dart';
import 'package:example/features/demos/guard/authwalled_screen.dart';
import 'package:example/features/demos/nested_routes/inbox_screen.dart';
import 'package:example/features/demos/value_based/product_list/product_list_screen.dart';
import 'package:example/features/home/widgets/header.dart';
import 'package:example/features/home/widgets/usecase_banner.dart';
import 'package:example/features/utils/screen_sizes.dart';
import 'package:example/features/widgets/limit_width.dart';
import 'package:flutter/material.dart';
import 'package:hyper_router/hyper_router.dart';


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
            context.hyper.navigate(ProductListScreen.routeName);
          },
          minimized: cons.maxWidth < compactWidth,
          image: 'assets/home/typesafe.jpeg',
          title: 'Value-based navigation',
          caption: 'Pass an object to another screen',
        ),
        UsecaseBanner(
          onPressed: () {
            context.hyper.navigate(InboxScreen.routeName);
          },
          minimized: cons.maxWidth < compactWidth,
          image: 'assets/home/nested.jpeg',
          title: 'Nested routes',
          caption: 'A screen with a navigation bar',
        ),
        UsecaseBanner(
          onPressed: () async {
            context.hyper.navigate(DialogExamplesScreen.routeName);
          },
          minimized: cons.maxWidth < compactWidth,
          image: 'assets/home/dialog.jpeg',
          title: 'Return value from a route',
          caption: 'Show input dialog and return the value',
        ),
        UsecaseBanner(
          onPressed: () {
            context.hyper.navigate(AuthwalledScreen.routeName);
          },
          minimized: cons.maxWidth < compactWidth,
          image: 'assets/home/guards.jpeg',
          title: 'Guards',
          caption: '''Redirect to the login page if not logged in. 
Can subscribe to the context.''',
        ),
        UsecaseBanner(
          onPressed: () {
            context.hyper.navigate(EmailListScreen.routeName);
          },
          minimized: cons.maxWidth < compactWidth,
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
