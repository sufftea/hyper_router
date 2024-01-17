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

    final controller = FractalRoot(
      initialRoute: initialRoute,
      roots: routes,
    );

    routerDelegate = FractalRouterDelegate(
      routerConfig: this,
      rootController: controller,
      redirect: redirect ?? _defaultRedirect,
    );
  }

  static FractalController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedFractalRouter>()!
        .rootController;
  }

  static FractalRoot rootOf(BuildContext context) {
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
  final FractalRoot rootController;

  @override
  bool updateShouldNotify(InheritedFractalRouter oldWidget) {
    return oldWidget.router != router ||
        oldWidget.rootController != rootController;
  }
}
