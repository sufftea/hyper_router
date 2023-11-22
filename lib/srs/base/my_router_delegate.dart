import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/base/my_router.dart';
import 'package:flutter_stack_router/srs/tree/my_route.dart';

abstract class RouterDelegateNotifier extends ChangeNotifier {
  MyRoute get stackRoot;
}

class MyRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  MyRouterDelegate({
    required this.router,
    required this.notifier,
  });

  final RouterDelegateNotifier notifier;
  final MyRouter router;

  @override
  Widget build(BuildContext context) {
    return InheritedMyRouter(
      router: router,
      child: AnimatedBuilder(
        animation: notifier,
        builder: (context, child) {
          final pages = MyRoute.createPages(context, notifier.stackRoot);
          
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
    MyRoute r = notifier.stackRoot;

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
