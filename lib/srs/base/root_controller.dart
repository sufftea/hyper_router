import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractal_router/srs/base/controller.dart';
import 'package:fractal_router/srs/base/nested_navigator.dart';
import 'package:fractal_router/srs/route/froute.dart';
import 'package:fractal_router/srs/value/route_value.dart';

class RootController extends ChangeNotifier implements FractalController {
  RootController({
    required List<Froute> roots,
    required RouteValue initialRoute,
    required this.routeMap,
  }) {
    navigate(initialRoute);
  }

  final rootNavigatorNode = NavigatorNode(GlobalKey<NavigatorState>());

  PageBuilder? _stack;
  PageBuilder get stack => _stack!;
  set stack(PageBuilder s) {
    _stack = s;
    notifyListeners();
  }

  final Map<Object, Froute> routeMap;

  @override
  void navigate(RouteValue target, [Set<RouteValue> values = const {}]) {
    stack = createStack(target, values);
  }

  @override
  bool pop<T>([T? result]) {
    return rootNavigatorNode.pop(result);
  }

  @override
  Future push(RouteValue target) {
    final currRoute = routeMap[stack.last().key];

    if (currRoute == null) {
      throw 'todo';
    }

    final targetRoute = currRoute.children
        .where((element) => element.key == target.key)
        .firstOrNull;

    if (targetRoute == null) {
      throw 'todo';
    }

    stack = targetRoute.createBuilderRec(values: {});

    return stack.last().popCompleter.future;
  }

  void navigateSilent(RouteValue target) {
    _stack = createStack(target);
  }

  PageBuilder createStack(
    RouteValue target, [
    Set<RouteValue> values = const {},
  ]) {
    final Froute? targetRoute = routeMap[target.key];

    if (targetRoute == null) {
      throw 'todo';
    }

    final valuesMap = <Object, RouteValue>{
      for (final v in values) v.key: v,
    };
    _stack?.forEach((builder) {
      valuesMap[builder.value.key] = builder.value;
    });
    valuesMap[target.key] = target;

    return targetRoute.createBuilderRec(values: valuesMap);
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
