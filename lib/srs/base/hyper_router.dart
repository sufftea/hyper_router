import 'package:flutter/material.dart';
import 'package:hyper_router/srs/base/entities.dart';
import 'package:hyper_router/srs/base/hyper_controller.dart';
import 'package:hyper_router/srs/base/delegate.dart';
import 'package:hyper_router/srs/base/exceptions.dart';
import 'package:hyper_router/srs/url/route_information_parser.dart';
import 'package:hyper_router/srs/route/hyper_route.dart';
import 'package:hyper_router/srs/value/route_value.dart';
import 'package:hyper_router/srs/base/root_hyper_controller.dart';

RouteValue? _defaultRedirect(BuildContext? _, RedirectState __) => null;
RouteValue? _defaultOnException(OnExceptionState error) => null;

class HyperRouter implements RouterConfig<Object> {
  HyperRouter({
    required RouteValue initialRoute,
    required this.routes,
    RouteValue? Function(OnExceptionState state)? onException,
    bool enableWeb = false,
    this.redirect = _defaultRedirect,
  }) : onException = onException ?? _defaultOnException {
    for (final r in routes) {
      r.parent = null;
    }

    final routeMap = <Object, HyperRoute>{};
    for (final r in routes) {
      r.forEach((r) {
        if (routeMap.containsKey(r.key)) {
          throw HyperError('Duplicate key detected: ${r.key}');
        }

        routeMap[r.key] = r;
      });
    }

    rootController = RootHyperController(
      initialRoute: initialRoute,
      redirect: redirect,
      routeMap: routeMap,
    );

    routerDelegate = HyperRouterDelegate(
      initialRoute: initialRoute,
      routerConfig: this,
    );

    if (enableWeb) {
      routeInformationParser = HyperRouteInformationParser(
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

  HyperController get controller => rootController;
  late final RootHyperController rootController;
  final List<HyperRoute> routes;
  final RouteValue? Function(
    BuildContext context,
    RedirectState state,
  ) redirect;
  final RouteValue? Function(OnExceptionState state) onException;

  static HyperController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedHyperTree>()!
        .router
        .rootController;
  }

  static RootHyperController rootOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedHyperTree>()!
        .router
        .rootController;
  }

  static HyperRouter configOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedHyperTree>()!
        .router;
  }

  @override
  final RootBackButtonDispatcher backButtonDispatcher =
      RootBackButtonDispatcher();

  @override
  late final HyperRouterDelegate routerDelegate;

  @override
  late final RouteInformationParser<Object>? routeInformationParser;

  @override
  late final RouteInformationProvider? routeInformationProvider;
}

class InheritedHyperTree extends InheritedWidget {
  const InheritedHyperTree({
    required this.router,
    required super.child,
    super.key,
  });

  final HyperRouter router;

  @override
  bool updateShouldNotify(InheritedHyperTree oldWidget) {
    return oldWidget.router != router;
  }
}
