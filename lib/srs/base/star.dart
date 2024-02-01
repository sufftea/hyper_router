import 'package:flutter/material.dart';
import 'package:star/srs/base/star_controller.dart';
import 'package:star/srs/base/delegate.dart';
import 'package:star/srs/base/exceptions.dart';
import 'package:star/srs/url/route_information_parser.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/value/route_value.dart';
import 'package:star/srs/base/root_star_controller.dart';

RouteValue? _defaultRedirect(RouteNode _) => null;

class Star implements RouterConfig<Object> {
  Star({
    required RouteValue initialRoute,
    required this.routes,
    bool enableWeb = false,
    RouteValue? Function(RouteNode stack) redirect = _defaultRedirect,
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
      redirect: redirect,
      routeMap: routeMap,
    );

    routerDelegate = StarRouterDelegate(routerConfig: this);

    if (enableWeb) {
      routeInformationParser = StarRouteInformationParser(roots: routes);

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

  late final RootStarController rootController;
  final List<StarRoute> routes;

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
  late final StarRouterDelegate routerDelegate;

  @override
  late final RouteInformationParser<Object>? routeInformationParser;

  @override
  late final RouteInformationProvider? routeInformationProvider;
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
