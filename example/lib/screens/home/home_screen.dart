import 'package:example/screens/number_screens/number_screens.dart';
import 'package:example/screens/random/random_screen.dart';
import 'package:flutter/material.dart';
import 'package:tree_router/tree_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeValue = RouteName('home');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Home'),
              OutlinedButton(
                onPressed: () {
                  debugPrint('navigating to randomscreen');
                  TreeRouter.of(context).navigate(RandomScreen.routeValue);
                },
                child: const Text('open a screen on top'),
              ),
              OutlinedButton(
                onPressed: () {
                  TreeRouter.of(context).navigate(TwoScreen.routeName);
                },
                child: const Text('another shell route'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
