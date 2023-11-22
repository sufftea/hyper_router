import 'package:flutter/material.dart';
import 'package:tea_router/srs/base/tea_router_delegate.dart';
import 'package:tea_router/srs/tree/tea_route.dart';
import 'package:tea_router/srs/tree/route_value.dart';
import 'package:tea_router/srs/base/tea_router_controller.dart';

class TeaRouter implements RouterConfig<Object> {
  TeaRouter({
    required RouteValue initialRoute,
    required List<TeaRoute> routes,
    BackButtonDispatcher? backButtonDispatcher,
  }) : backButtonDispatcher =
            backButtonDispatcher ?? RootBackButtonDispatcher() {
    for (final r in routes) {
      r.parent = null;
    }

    controller = TeaRouterController(
      initialRoute: initialRoute,
      roots: routes,
    );

    routerDelegate = TeaRouterDelegate(
      router: this,
      notifier: controller,
    );
  }

  late final TeaRouterController controller;

  static TeaRouterController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedMyRouter>()!
        .router
        .controller;
  }

  static TeaRouter configOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedMyRouter>()!
        .router;
  }

  @override
  final BackButtonDispatcher backButtonDispatcher;

  @override
  late final TeaRouterDelegate routerDelegate;

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

  final TeaRouter router;

  @override
  bool updateShouldNotify(InheritedMyRouter oldWidget) {
    return oldWidget.router != router;
  }
}
