import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/base/my_router_delegate.dart';
import 'package:flutter_stack_router/srs/tree/my_route.dart';
import 'package:flutter_stack_router/srs/tree/route_value.dart';
import 'package:flutter_stack_router/srs/base/my_router_controller.dart';

class MyRouter implements RouterConfig<Object> {
  MyRouter({
    required RouteValue initialRoute,
    required List<MyRoute> routes,
    BackButtonDispatcher? backButtonDispatcher,
  }) : backButtonDispatcher =
            backButtonDispatcher ?? RootBackButtonDispatcher() {
    for (final r in routes) {
      r.parent = null;
    }

    controller = MyRouterController(
      initialRoute: initialRoute,
      roots: routes,
    );

    routerDelegate = MyRouterDelegate(
      router: this,
      notifier: controller,
    );
  }

  late final MyRouterController controller;

  static MyRouterController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedMyRouter>()!
        .router
        .controller;
  }

  static MyRouter configOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedMyRouter>()!
        .router;
  }

  @override
  final BackButtonDispatcher backButtonDispatcher;

  @override
  late final MyRouterDelegate routerDelegate;

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

  final MyRouter router;

  @override
  bool updateShouldNotify(InheritedMyRouter oldWidget) {
    return oldWidget.router != router;
  }
}
