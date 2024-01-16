import 'package:example/features/home/widgets/usecase_banner.dart';
import 'package:flutter/material.dart';
import 'package:fractal_router/fractal_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = RouteName('home');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.amber.shade300,
              ),
            ),
            const Center(
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  UsecaseBanner(
                    header: 'Declarative API',
                    caption:
                        'Configure the route tree; navigate anywhere from anywhere',
                  ),
                  UsecaseBanner(
                    header: 'Value-based navigation',
                    caption:
                        'Pass type-safe parameters to the routes with minimal boilerplate and no codegen!',
                  ),
                  UsecaseBanner(
                    header: 'Nested routes',
                    caption:
                        'Allows creating nested routes with bottom navigation bar',
                  ),
                  UsecaseBanner(
                    header: 'Show dialog',
                    caption: 'TODO: returning value from a route',
                  ),
                  UsecaseBanner(
                    header: 'Super extensible',
                    caption: 'You can easily extend built in classes for specialized use-cases',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
