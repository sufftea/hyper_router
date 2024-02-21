import 'package:example/features/demos/nested_routes/inbox_subroute_screen.dart';
import 'package:example/features/demos/nested_routes/on_top_screen.dart';
import 'package:example/features/widgets/limit_width.dart';
import 'package:flutter/material.dart';
import 'package:hyper_router/hyper_router.dart';


class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  static const routeName = RouteName('inbox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.hyper.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: LimitWidth(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(64),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset('assets/nested/inbox.jpeg'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Inbox',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.hyper.navigate(InboxSubrouteScreen.routeName);
              },
              child: const Text('Open subroute'),
            ),
            TextButton(
              onPressed: () {
                context.hyper.navigate(CoveringScreen.routeName);
              },
              child: const Text('Open route on top of the shell'),
            ),
          ],
        ),
      ),
    );
  }
}
