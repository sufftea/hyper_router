import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/base/my_router.dart';
import 'package:flutter_stack_router/srs/base/my_router_delegate.dart';
import 'package:flutter_stack_router/srs/tree/my_route.dart';

class NestedMyRouter extends StatelessWidget {
  const NestedMyRouter({
    required List<MyRoute> roots,
    required this.notifier,
    super.key,
  });

  final RouterDelegateNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final router = MyRouter.configOf(context);

    final delegate = MyRouterDelegate(
      router: router,
      notifier: notifier,
    );

    return Router(
      routerDelegate: delegate,
      backButtonDispatcher: ChildBackButtonDispatcher(
        router.backButtonDispatcher,
      )..takePriority(),
    );
  }
}
