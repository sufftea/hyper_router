import 'package:example/screens/post/post_screen.dart';
import 'package:example/screens/profile/profile_screen.dart';
import 'package:example/screens/tab_bar/tab_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stack_router/destination.dart';
import 'package:flutter_stack_router/route_stack.dart';
import 'package:flutter_stack_router/stack_router.dart';

class HomeRouteData {
  const HomeRouteData();
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  static final destination = ScreenDestination<HomeRouteData>(
    screenBuilder: (context, value) {
      return const HomeScreen();
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('home screen'),
            ElevatedButton(
              onPressed: () {
                final routerState = StackRouter.stateOf(context);

                routerState.push(const TabBarRouteData());
              },
              child: const Text('open another tab screen'),
            ),
          ],
        ),
      ),
    );
  }
}
