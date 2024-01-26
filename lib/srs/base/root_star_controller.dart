import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star/srs/base/star_controller.dart';
import 'package:star/srs/base/nested_navigator.dart';
import 'package:star/srs/base/star_error.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/value/route_value.dart';

class RootStarController extends ChangeNotifier implements StarController {
  RootStarController({
    required List<StarRoute> roots,
    required RouteValue initialRoute,
    required this.routeMap,
  }) {
    navigate(initialRoute);
  }

  final rootNavigatorNode = NavigatorNode(GlobalKey<NavigatorState>());

  RouteNode? _stack;
  RouteNode get stack => _stack!;
  set stack(RouteNode s) {
    _stack = s;
    notifyListeners();
  }

  final Map<Object, StarRoute> routeMap;

  @override
  Future navigate(RouteValue target, [Set<RouteValue> values = const {}]) {
    stack = createStack(target, values);
    return stack.last().popCompleter.future;
  }

  @override
  void pop<T>([T? result]) {
    if (!rootNavigatorNode.pop(result)) {
      SystemNavigator.pop();
    }
  }

  /// Updates the stack without notifying listeners
  void navigateSilent(RouteValue target) {
    _stack = createStack(target);
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

    final valuesMap = <Object, RouteValue>{
      for (final v in values) v.key: v,
    };
    _stack?.forEach((builder) {
      valuesMap[builder.value.key] = builder.value;
    });
    valuesMap[target.key] = target;

    return targetRoute.createNodeRec(values: valuesMap);
  }

  void popRoute<T>(T? result) {
    stack.last().popCompleter.complete(result);

    if (stack.pop() case final popped?) {
      stack = popped;
    } else {
      SystemNavigator.pop();
    }
  }

  List<Page> createPages(BuildContext context) {
    return stack.createPages(context);
  }
}
