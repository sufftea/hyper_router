import 'package:flutter/material.dart';
import 'package:star/srs/base/star_controller.dart';
import 'package:star/srs/base/delegate.dart';
import 'package:star/srs/base/exceptions.dart';
import 'package:star/srs/url/route_information_parser.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/value/route_value.dart';
import 'package:star/srs/base/root_star_controller.dart';

RouteValue? _defaultRedirect(BuildContext? _, RouteNode __) => null;

class Star implements RouterConfig<Object> {
  Star({
    required RouteValue initialRoute,
    required this.routes,
    RouteValue? errorRoute,
    bool enableWeb = false,
    this.redirect = _defaultRedirect,
  }) : errorRoute = errorRoute ?? initialRoute {
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
      redirect: redirect,
      routeMap: routeMap,
    );

    routerDelegate = StarRouterDelegate(
      initialRoute: initialRoute,
      routerConfig: this,
    );

    if (enableWeb) {
      routeInformationParser = StarRouteInformationParser(
        config: this,
      );

      final u = routeInformationParser!
          .restoreRouteInformation(rootController.stack)!;

      routeInformationProvider = PlatformRouteInformationProvider(
        initialRouteInformation: u,
      );
    } else {
      routeInformationParser = null;
      routeInformationProvider = null;
    }
  }

  StarController get controller => rootController;
  late final RootStarController rootController;
  final List<StarRoute> routes;
  final RouteValue? Function(BuildContext context, RouteNode stack) redirect;
  final RouteValue errorRoute;

  static StarController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedStarRouter>()!
        .router
        .rootController;
  }

  static RootStarController rootOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedStarRouter>()!
        .router
        .rootController;
  }

  static Star configOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedStarRouter>()!
        .router;
  }

  @override
  final RootBackButtonDispatcher backButtonDispatcher =
      RootBackButtonDispatcher();

  @override
  late final StarRouterDelegate routerDelegate;

  @override
  late final RouteInformationParser<Object>? routeInformationParser;

  @override
  late final RouteInformationProvider? routeInformationProvider;
}

class InheritedStarRouter extends InheritedWidget {
  const InheritedStarRouter({
    required this.router,
    required super.child,
    super.key,
  });

  final Star router;

  @override
  bool updateShouldNotify(InheritedStarRouter oldWidget) {
    return oldWidget.router != router;
  }
}
