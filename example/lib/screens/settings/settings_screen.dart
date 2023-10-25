import 'package:example/screens/post/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stack_router/stack_router.dart';

class SettingsRouteData {
  const SettingsRouteData();
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('settings screen'),
            ElevatedButton(
              onPressed: () {
                StackRouter.stateOf(context).push(
                  const PostRouteData('another route on top'),
                );
              },
              child: const Text('push a route on top'),
            ),
          ],
        ),
      ),
    );
  }
}
