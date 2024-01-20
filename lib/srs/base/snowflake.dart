import 'package:flutter/material.dart';
import 'package:snowflake_route/srs/base/flake_controller.dart';
import 'package:snowflake_route/srs/base/delegate.dart';
import 'package:snowflake_route/srs/route/flake_route.dart';
import 'package:snowflake_route/srs/value/route_value.dart';
import 'package:snowflake_route/srs/base/root_controller.dart';

typedef RedirectCallback = RouteValue? Function(
  BuildContext context,
  PageBuilder stack,
);
RouteValue? _defaultRedirect(BuildContext context, PageBuilder _) => null;

class Snowflake implements RouterConfig<Object> {
  Snowflake({
    required RouteValue initialRoute,
    required List<FlakeRoute> routes,
    RedirectCallback? redirect,
  }) {
    for (final r in routes) {
      r.parent = null;
    }

    final routeMap = <Object, FlakeRoute>{};
    for (final r in routes) {
      r.forEach((r) {
        routeMap[r.key] = r;
      });
    }

    rootController = RootController(
      initialRoute: initialRoute,
      roots: routes,
      routeMap: routeMap,
    );

    routerDelegate = FlakeRouterDelegate(
      routerConfig: this,
      redirect: redirect ?? _defaultRedirect,
    );
  }

  late final RootController rootController;

  static FlakeController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFractalRouter>()!
        .router
        .rootController;
  }

  static RootController rootOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFractalRouter>()!
        .router
        .rootController;
  }

  static Snowflake configOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFractalRouter>()!
        .router;
  }

  @override
  final RootBackButtonDispatcher backButtonDispatcher =
      RootBackButtonDispatcher();

  @override
  late final FlakeRouterDelegate routerDelegate;

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

  final Snowflake router;

  @override
  bool updateShouldNotify(InheritedFractalRouter oldWidget) {
    return oldWidget.router != router;
  }
}
