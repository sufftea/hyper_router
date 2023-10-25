import 'package:flutter/material.dart';
import 'package:flutter_stack_router/route_stack.dart';

/// Builds a route with the value of type T, when such is added to the stack.
abstract class Destination<T> {
  const Destination();

  Type get valueType => T;

  Widget buildScreen(BuildContext context, T value);
  
  Widget buildScreenWrapped(BuildContext context, T value, RouteStack currStack) {
    return InheritedRouteStack(
      stack: currStack,
      child: buildScreen(context, value),
    );
  }
}

typedef ScreenBuilder<T> = Widget Function(BuildContext context, T value);

class ScreenDestination<T> extends Destination<T> {
  ScreenDestination({
    required this.screenBuilder,
  });

  final ScreenBuilder<T> screenBuilder;

  @override
  Widget buildScreen(BuildContext context, T value) {
    return screenBuilder(context, value);
  }
}
