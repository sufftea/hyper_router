import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tea_router/srs/base/tea_router.dart';
import 'package:tea_router/srs/tree/route_context.dart';
import 'package:tea_router/srs/tree/tea_route.dart';

abstract class RouterDelegateNotifier extends ChangeNotifier {
  TeaRoute get stackRoot;
}

class TeaRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  TeaRouterDelegate({
    required this.router,
    required this.notifier,
  });

  final RouterDelegateNotifier notifier;
  final TeaRouter router;

  @override
  Widget build(BuildContext context) {
    return InheritedMyRouter(
      router: router,
      child: AnimatedBuilder(
        animation: notifier,
        builder: (context, child) {
          final pages = notifier.stackRoot.createPages(context);

          return Navigator(
            pages: pages,
            onPopPage: (route, result) {
              return true;
            },
          );
        },
      ),
    );
  }

  @override
  Future<bool> popRoute() async {
    TeaRoute r = notifier.stackRoot;

    if (r.next == null) {
      return SynchronousFuture(false);
    }

    while (r.next!.next != null) {
      r = r.next!;
    }

    r.next = null;

    return SynchronousFuture(true);
  }

  @override
  Future<void> setNewRoutePath(Object configuration) {
    throw UnimplementedError();
  }

  // @override
  // Future<void> setNewRoutePath(RouteStack configuration) {
  //   controller.stack = configuration;
  //   return SynchronousFuture(null);
  // }

  // @override
  // Future<void> setInitialRoutePath(RouteStack configuration) {
  //   return setNewRoutePath(configuration);
  // }
}
