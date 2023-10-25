library flutter_stack_router;

import 'package:flutter/material.dart';
import 'package:flutter_stack_router/destination.dart';
import 'package:flutter_stack_router/destination_mapper.dart';
import 'package:flutter_stack_router/stack_router_delegate.dart';
import 'package:flutter_stack_router/route_stack.dart';

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

abstract class StackRouterControllerBase extends ChangeNotifier {
  RouteStack get stack;
  set stack(RouteStack value);
}

class StackRouterController extends StackRouterControllerBase {
  StackRouterController({
    required RouteStack initialStack,
  }) : _stack = initialStack;

  RouteStack _stack;

  @override
  RouteStack get stack => _stack;

  @override
  set stack(RouteStack value) {
    _stack = value;
    notifyListeners();
  }
}

class TabStackRouterController extends StackRouterControllerBase {
  TabStackRouterController({
    required List<RouteStack> tabs,
    required initialTab,
  })  : _currentTab = initialTab,
        _tabs = tabs;

  int _currentTab;
  final List<RouteStack> _tabs;

  int get tab => _currentTab;
  set tab(int index) {
    _currentTab = index;
    notifyListeners();
  }

  @override
  RouteStack get stack => _tabs[_currentTab];
  @override
  set stack(RouteStack value) {
    _tabs[_currentTab] = value;
    notifyListeners();
  }
}
