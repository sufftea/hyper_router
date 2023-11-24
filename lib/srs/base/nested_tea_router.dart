import 'package:flutter/material.dart';
import 'package:tea_router/srs/base/tea_router.dart';
import 'package:tea_router/srs/base/tea_router_delegate.dart';
import 'package:tea_router/srs/tree/tea_route.dart';

class NestedTeaRouter extends StatelessWidget {
  const NestedTeaRouter({
    required List<TeaRoute> roots,
    required this.notifier,
    required this.backButtonDispatcher,
    super.key,
  });

  /// Needs to be created and activated (`takePriority`) outside!!!
  final BackButtonDispatcher backButtonDispatcher;
  final RouterDelegateNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final router = TeaRouter.configOf(context);

    final delegate = TeaRouterDelegate(
      router: router,
      notifier: notifier,
    );

    return Router(
      routerDelegate: delegate,
      backButtonDispatcher: backButtonDispatcher,
    );
  }
}
