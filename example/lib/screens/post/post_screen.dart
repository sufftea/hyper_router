import 'package:flutter/material.dart';
import 'package:flutter_stack_router/destination.dart';
import 'package:flutter_stack_router/route_stack.dart';
import 'package:flutter_stack_router/stack_router.dart';

class PostRouteData {
  const PostRouteData(this.content);
  final String content;
}

class PostScreen extends StatelessWidget {
  const PostScreen({
    required this.data,
    super.key,
  });

  final PostRouteData data;

  static final destination = ScreenDestination<PostRouteData>(
    screenBuilder: (context, value) {
      return PostScreen(data: value);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(data.content),
            OutlinedButton(
              onPressed: () {
                StackRouter.stateOf(context)
                    .push(const PostRouteData('some value'));
                // MyRouter.push(context, const ProfileRouteData('anotherUserId'));
              },
              child: const Text('push another'),
            ),
            OutlinedButton(
              onPressed: () {
                StackRouter.stateOf(context).controller.stack = RouteStack([
                  data,
                  const PostRouteData('1'),
                  const PostRouteData('2'),
                  const PostRouteData('3'),
                ]);
                // MyRouter.push(context, const ProfileRouteData('anotherUserId'));
              },
              child: const Text('set stack'),
            ),
          ],
        ),
      ),
    );
  }
}
