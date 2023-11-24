import 'package:flutter/material.dart';
import 'package:tree_router/srs/base/tree_router.dart';
import 'package:tree_router/srs/base/tree_router_delegate.dart';
import 'package:tree_router/srs/tree/tree_route.dart';

class NestedRouter extends StatelessWidget {
  const NestedRouter({
    required List<TreeRoute> roots,
    required this.notifier,
    required this.backButtonDispatcher,
    super.key,
  });

  /// Needs to be created and activated (`takePriority`) outside!!!
  final BackButtonDispatcher backButtonDispatcher;
  final RouterDelegateNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final router = TreeRouter.configOf(context);

    final delegate = TreeRouterDelegate(
      router: router,
      notifier: notifier,
    );

    return Router(
      routerDelegate: delegate,
      backButtonDispatcher: backButtonDispatcher,
    );
  }
}
