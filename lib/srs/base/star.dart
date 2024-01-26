import 'package:flutter/material.dart';
import 'package:star/srs/base/star_controller.dart';
import 'package:star/srs/base/delegate.dart';
import 'package:star/srs/base/star_error.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/value/route_value.dart';
import 'package:star/srs/base/root_star_controller.dart';

typedef RedirectCallback = RouteValue? Function(
  BuildContext context,
  RouteNode stack,
);
RouteValue? _defaultRedirect(BuildContext context, RouteNode _) => null;

class Star implements RouterConfig<Object> {
  Star({
    required RouteValue initialRoute,
    required List<StarRoute> routes,
    RedirectCallback redirect = _defaultRedirect,
  }) {
    for (final r in routes) {
      r.parent = null;
    }

    final routeMap = <Object, StarRoute>{};
    for (final r in routes) {
      r.forEach((r) {
        if (routeMap.containsKey(r.key)) {
          throw StarError('Duplicate key detected: ${r.key}');
        }

        routeMap[r.key] = r;
      });
    }

    rootController = RootStarController(
      initialRoute: initialRoute,
      roots: routes,
      routeMap: routeMap,
    );

    routerDelegate = FlakeRouterDelegate(
      routerConfig: this,
      redirect: redirect,
    );
  }

  late final RootStarController rootController;

  static StarController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFractalRouter>()!
        .router
        .rootController;
  }

  static RootStarController rootOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFractalRouter>()!
        .router
        .rootController;
  }

  static Star configOf(BuildContext context) {
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

  final Star router;

  @override
  bool updateShouldNotify(InheritedFractalRouter oldWidget) {
    return oldWidget.router != router;
  }
}
