import 'package:flutter/material.dart';
import 'package:tree_router/srs/base/tree_router_controller.dart';
import 'package:tree_router/srs/base/tree_router_delegate.dart';
import 'package:tree_router/srs/tree/tree_route.dart';
import 'package:tree_router/srs/tree/route_value.dart';
import 'package:tree_router/srs/base/root_tree_router_controller.dart';

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

    controller = RootTreeRouterController(
      initialRoute: initialRoute,
      roots: routes,
    );

    routerDelegate = TreeRouterDelegate(
      routerConfig: this,
      rootController: controller,
    );
  }

  late final RootTreeRouterController controller;

  static RootTreeRouterController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedTreeRouter>()!
        .router
        .controller;
  }

  static TreeRouterControllerMixin controllerOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedRouterController>()!
        .controller;
  }

  static TreeRouter configOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedTreeRouter>()!
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

class InheritedTreeRouter extends InheritedWidget {
  const InheritedTreeRouter({
    required this.router,
    required super.child,
    super.key,
  });

  final TreeRouter router;

  @override
  bool updateShouldNotify(InheritedTreeRouter oldWidget) {
    return oldWidget.router != router;
  }
}

class InheritedRouterController extends InheritedWidget {
  const InheritedRouterController({
    required this.controller,
    required super.child,
    super.key,
  });

  final TreeRouterControllerMixin controller;

  @override
  bool updateShouldNotify(InheritedRouterController oldWidget) {
    return oldWidget.controller != controller;
  }
}