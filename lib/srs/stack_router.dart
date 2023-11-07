
import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/destination.dart';
import 'package:flutter_stack_router/srs/internal/destination_mapper.dart';
import 'package:flutter_stack_router/srs/stack_router_controller.dart';
import 'package:flutter_stack_router/srs/internal/stack_router_delegate.dart';
import 'package:flutter_stack_router/srs/route_stack.dart';

class StackRouter implements RouterConfig<Object> {
  StackRouter({
    required this.controller,
    List<Destination>? destinations,
    DestinationMapper? destinationMapper,
    BackButtonDispatcher? backButtonDispatcher,
  })  : assert((destinations == null) ^ (destinationMapper == null),
            "Either [destinations] or [destinationMapper] must be null"),
        backButtonDispatcher =
            backButtonDispatcher ?? RootBackButtonDispatcher(),
        destinationMapper =
            destinationMapper ?? DestinationMapper(destinations!) {
    routerDelegate = StackRouterDelegate(
      router: this,
      controller: controller,
      destinationMapper: this.destinationMapper,
    );
  }

  final DestinationMapper destinationMapper;
  final StackRouterControllerBase controller;

  // static MyRouter rootOf(BuildContext context) {
  // }

  static StackRouter of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedStackRouter>()!
        .router;
  }

  static StackRouterState stateOf(BuildContext context) {
    final router = of(context);

    final stack = context
        .dependOnInheritedWidgetOfExactType<InheritedRouteStack>()!
        .stack;

    return StackRouterState(
      context,
      localStack: stack,
      router: router,
    );
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
    required StackRouter router,
  }) : _router = router;

  final StackRouter _router;
  final RouteStack localStack;
  final BuildContext context;

  StackRouterControllerBase get controller => _router.controller;

  void push(Object value) {
    controller.stack = localStack.pushed(value);
  }

  void pop() {
    controller.stack = localStack.popped();
  }
}
