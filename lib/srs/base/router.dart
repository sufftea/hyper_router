import 'package:flutter/material.dart';
import 'package:fractal_router/srs/base/delegate.dart';
import 'package:fractal_router/srs/route/froute.dart';
import 'package:fractal_router/srs/value/route_value.dart';
import 'package:fractal_router/srs/base/controller.dart';

typedef RedirectCallback = RouteValue? Function(
  BuildContext context,
  PageBuilder stack,
);
RouteValue? _defaultRedirect(BuildContext context, PageBuilder _) => null;

class FractalRouter implements RouterConfig<Object> {
  FractalRouter({
    required RouteValue initialRoute,
    required List<Froute> routes,
    RedirectCallback? redirect,
  }) {
    for (final r in routes) {
      r.parent = null;
    }

    final routeMap = <Object, Froute>{};
    for (final r in routes) {
      r.forEach((r) {
        routeMap[r.key] = r;
      });
    }

    rootController = FractalRoot(
      initialRoute: initialRoute,
      roots: routes,
      routeMap: routeMap,
    );

    routerDelegate = FractalRouterDelegate(
      routerConfig: this,
      redirect: redirect ?? _defaultRedirect,
    );
  }

  late final FractalRoot rootController;

  static FractalController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFractalRouter>()!
        .router
        .rootController;
  }

  static FractalRoot rootOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFractalRouter>()!
        .router
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
    required super.child,
    super.key,
  });

  final FractalRouter router;

  @override
  bool updateShouldNotify(InheritedFractalRouter oldWidget) {
    return oldWidget.router != router;
  }
}
