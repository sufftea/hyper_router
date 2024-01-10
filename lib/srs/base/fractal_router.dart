import 'package:flutter/material.dart';
import 'package:fractal_router/srs/base/fractal_router_delegate.dart';
import 'package:fractal_router/srs/tree/froute.dart';
import 'package:fractal_router/srs/tree/route_value.dart';
import 'package:fractal_router/srs/base/fractal_controller.dart';

class FractalRouter implements RouterConfig<Object> {
  FractalRouter({
    required RouteValue initialRoute,
    required List<Froute> routes,
    BackButtonDispatcher? backButtonDispatcher,
  }) : backButtonDispatcher =
            backButtonDispatcher ?? RootBackButtonDispatcher() {
    for (final r in routes) {
      r.parent = null;
    }

    controller = FractalController(
      initialRoute: initialRoute,
      roots: routes,
    );

    routerDelegate = FractalRouterDelegate(
      routerConfig: this,
      controller: controller,
    );
  }

  late final FractalController controller;

  static FractalController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFractalRouter>()!
        .router
        .controller;
  }

  static FractalRouter configOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFractalRouter>()!
        .router;
  }

  @override
  final BackButtonDispatcher backButtonDispatcher;

  @override
  late final FractalRouterDelegate routerDelegate;

  @override
  // TODO
  final RouteInformationParser<Object>? routeInformationParser = null;

  @override
  // TODO
  final RouteInformationProvider? routeInformationProvider = null;
}

class InheritedFractalRouter extends InheritedWidget {
  const InheritedFractalRouter({
    required this.router,
    required super.child,
    super.key,
  });

  final FractalRouter router;

  @override
  bool updateShouldNotify(InheritedFractalRouter oldWidget) {
    return oldWidget.router != router;
  }
}