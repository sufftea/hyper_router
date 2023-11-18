import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/destination/destination.dart';
import 'package:flutter_stack_router/srs/internal/destination_mapper.dart';
import 'package:flutter_stack_router/srs/stack_router_controller.dart';
import 'package:flutter_stack_router/srs/internal/stack_router_delegate.dart';
import 'package:flutter_stack_router/srs/route_stack.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';

class StackRouter implements RouterConfig<Object> {
  StackRouter({
    required DestinationValue initialDestination,
    required List<Destination> destinations,
    BackButtonDispatcher? backButtonDispatcher,
  }) : backButtonDispatcher =
            backButtonDispatcher ?? RootBackButtonDispatcher() {
    final mapper = DestinationMapper(roots: destinations);

    controller = StackRouterController(
      initialDestination: initialDestination,
      mapper: mapper,
    );

    routerDelegate = StackRouterDelegate(
      router: this,
      controller: controller,
      destinationMapper: mapper,
    );
  }

  late final StackRouterController controller;

  static StackRouterController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedStackRouter>()!
        .router
        .controller;
  }

  static StackRouter configOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedStackRouter>()!
        .router;
  }

  @override
  final BackButtonDispatcher backButtonDispatcher;

  @override
  late final StackRouterDelegate routerDelegate;

  @override
  // TODO
  final RouteInformationParser<Object>? routeInformationParser = null;

  @override
  // TODO
  final RouteInformationProvider? routeInformationProvider = null;
}

class InheritedStackRouter extends InheritedWidget {
  const InheritedStackRouter({
    required this.router,
    required super.child,
    super.key,
  });

  final StackRouter router;

  @override
  bool updateShouldNotify(InheritedStackRouter oldWidget) {
    return oldWidget.router != router;
  }
}

class StackRouterState {
  const StackRouterState(
    this.context, {
    required this.localStack,
  });

  final RouteStack localStack;
  final BuildContext context;
}
