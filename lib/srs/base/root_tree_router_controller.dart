import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tree_router/srs/tree/tree_route.dart';
import 'package:tree_router/srs/tree/route_value.dart';

class RootTreeRouterController extends ChangeNotifier {
  RootTreeRouterController({
    required List<TreeRoute> roots,
    required RouteValue initialRoute,
  }) {
    for (final r in roots) {
      r.forEach((r) {
        _routeMap[r.key] = r;
      });
    }

    navigate(initialRoute);
  }

  PageBuilder? root;

  final Map<Object, TreeRoute> _routeMap = {};

  void navigate(RouteValue target, [Set<RouteValue> values = const {}]) {
    final TreeRoute? targetRoute = _routeMap[target.key];

    if (targetRoute == null) {
      throw 'todo';
    }

    final valuesMap = <Object, RouteValue>{
      for (final v in values) v.key: v,
    };
    root?.forEach((builder) {
      valuesMap[builder.value.key] = builder.value;
    });
    valuesMap[target.key] = target;

    root = targetRoute.createBuilderRec(values: valuesMap);

    notifyListeners();
  }

  void pop() {
    if (root?.pop() case final popped?) {
      root = popped;
    } else {
      SystemNavigator.pop();
    }

    notifyListeners();
  }

  List<Page> createPages(BuildContext context) {
    return root!.createPages(context);
  }
}

class InheritedRouterController extends InheritedWidget {
  const InheritedRouterController({
    required this.controller,
    required super.child,
    super.key,
  });

  final RootTreeRouterController controller;

  @override
  bool updateShouldNotify(InheritedRouterController oldWidget) {
    return oldWidget.controller != controller;
  }
}
