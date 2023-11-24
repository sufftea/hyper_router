import 'package:flutter/material.dart';
import 'package:tree_router/srs/base/tree_router_delegate.dart';
import 'package:tree_router/srs/tree/tree_route.dart';
import 'package:tree_router/srs/tree/route_value.dart';
import 'package:tree_router/srs/base/tree_router_controller.dart';

class TreeRouter implements RouterConfig<Object> {
  TreeRouter({
    required RouteValue initialRoute,
    required List<TreeRoute> routes,
    BackButtonDispatcher? backButtonDispatcher,
  }) : backButtonDispatcher =
            backButtonDispatcher ?? RootBackButtonDispatcher() {
    for (final r in routes) {
      r.parent = null;
    }

    controller = TreeRouterController(
      initialRoute: initialRoute,
      roots: routes,
    );

    routerDelegate = TreeRouterDelegate(
      router: this,
      notifier: controller,
    );
  }

  late final TreeRouterController controller;

  static TreeRouterController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedMyRouter>()!
        .router
        .controller;
  }

  static TreeRouter configOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedMyRouter>()!
        .router;
  }

  @override
  final BackButtonDispatcher backButtonDispatcher;

  @override
  late final TreeRouterDelegate routerDelegate;

  @override
  // TODO
  final RouteInformationParser<Object>? routeInformationParser = null;

  @override
  // TODO
  final RouteInformationProvider? routeInformationProvider = null;
}

class InheritedMyRouter extends InheritedWidget {
  const InheritedMyRouter({
    required this.router,
    required super.child,
    super.key,
  });

  final TreeRouter router;

  @override
  bool updateShouldNotify(InheritedMyRouter oldWidget) {
    return oldWidget.router != router;
  }
}
