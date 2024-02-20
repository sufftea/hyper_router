import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star/srs/base/entities.dart';
import 'package:star/srs/base/star.dart';
import 'package:star/srs/base/star_controller.dart';
import 'package:star/srs/base/nested_navigator.dart';
import 'package:star/srs/base/exceptions.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/value/route_value.dart';

class RootStarController extends ChangeNotifier implements StarController {
  RootStarController({
    required RouteValue initialRoute,
    required RouteValue? Function(BuildContext context, RedirectState state)
        redirect,
    required this.routeMap,
  }) {
    _redirect = (stack) {
      if (_redirectContext case final context?) {
        if (redirect(context, RedirectState(stack: stack)) case final target?) {
          return createStack(target);
        }
      }

      return stack;
    };

    _stack = createStack(initialRoute);
  }

  final rootNavigatorNode = NavigatorNode(GlobalKey<NavigatorState>());

  BuildContext? _redirectContext;
  late final RouteNode Function(RouteNode stack) _redirect;

  RouteNode? _stack;
  @override
  RouteNode get stack => _stack!;
  void setStack(RouteNode value, {bool notify = true}) {
    _stack = _redirect(value);
    if (notify) {
      notifyListeners();
    }
  }

  final Map<Object, StarRoute> routeMap;

  @override
  Future navigate(RouteValue target, [Set<RouteValue> values = const {}]) {
    setStack(createStack(target, values));
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
      setStack(popped);
    } else {
      SystemNavigator.pop();
    }
  }

  List<Page> createPages(BuildContext context) {
    return stack.createPages(context).toList();
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

    final valuesMap = extractValues();
    valuesMap[target.key] = target;

    return targetRoute.createStack(values: valuesMap)!;
  }

  Map<Object, RouteValue> extractValues() {
    final result = <Object, RouteValue>{};

    _stack?.forEach((builder) {
      result[builder.value.key] = builder.value;
    });

    return result;
  }
}

class RedirectWatcher extends StatefulWidget {
  const RedirectWatcher({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<RedirectWatcher> createState() => _RedirectWatcherState();
}

class _RedirectWatcherState extends State<RedirectWatcher> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.dependOnInheritedWidgetOfExactType<InheritedStarRouter>()!.router;
    final controller = Star.configOf(context).rootController;
    controller._redirectContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
