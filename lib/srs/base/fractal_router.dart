import 'package:flutter/material.dart';
import 'package:fractal_router/srs/base/delegate.dart';
import 'package:fractal_router/srs/tree/froute.dart';
import 'package:fractal_router/srs/tree/route_value.dart';
import 'package:fractal_router/srs/base/controller.dart';

class FractalRouter implements RouterConfig<Object> {
  FractalRouter({
    required RouteValue initialRoute,
    required List<Froute> routes,
  }) {
    for (final r in routes) {
      r.parent = null;
    }

    final controller = RootFractalController(
      initialRoute: initialRoute,
      roots: routes,
      dispatcher: backButtonDispatcher,
    );

    routerDelegate = FractalRouterDelegate(
      routerConfig: this,
      rootController: controller,
    );
  }

  static RootFractalController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFractalRouter>()!
        .rootController;
  }

  static FractalRouter configOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFractalRouter>()!
        .router;
  }

  @override
  final RootBackButtonDispatcher backButtonDispatcher =
      RootBackButtonDispatcher();

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
    required this.rootController,
    required super.child,
    super.key,
  });

  final FractalRouter router;
  final RootFractalController rootController;

  @override
  bool updateShouldNotify(InheritedFractalRouter oldWidget) {
    return oldWidget.router != router ||
        oldWidget.rootController != rootController;
  }
}
