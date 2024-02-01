import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star/srs/base/star_controller.dart';
import 'package:star/srs/base/nested_navigator.dart';
import 'package:star/srs/base/exceptions.dart';
import 'package:star/srs/base/star_state.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/value/route_value.dart';

class RootStarController implements StarController {
  RootStarController({
    required RouteValue initialRoute,
    required RouteValue? Function(RouteNode stack) redirect,
    required this.routeMap,
  }) {
    state = StarState(redirect: (stack) {
      if (redirect(stack) case final newTarget?) {
        return createStack(newTarget);
      }

      return stack;
    });

    state.updateSilent(createStack(initialRoute));
  }

  final rootNavigatorNode = NavigatorNode(GlobalKey<NavigatorState>());

  late final StarState state;
  RouteNode get stack => state.stack;

  final Map<Object, StarRoute> routeMap;

  @override
  Future navigate(RouteValue target, [Set<RouteValue> values = const {}]) {
    state.stack = createStack(target, values);
    return stack.last().popCompleter.future;
  }

  @override
  void pop<T>([T? result]) {
    if (!rootNavigatorNode.pop(result)) {
      SystemNavigator.pop();
    }
  }

  void popRoute<T>(T? result) {
    stack.last().popCompleter.complete(result);

    if (stack.pop() case final popped?) {
      state.stack = popped;
    } else {
      SystemNavigator.pop();
    }
  }

  List<Page> createPages(BuildContext context) {
    return stack.createPages(context);
  }

  RouteNode createStack(
    RouteValue target, [
    Set<RouteValue> values = const {},
  ]) {
    final StarRoute? targetRoute = routeMap[target.key];

    if (targetRoute == null) {
      throw StarError(
          "Route tree doesn't contain route with the provided key: ${target.key}");
    }

    final valuesMap = state.values;
    valuesMap[target.key] = target;

    return targetRoute.createNodeRec(values: valuesMap);
  }
}
