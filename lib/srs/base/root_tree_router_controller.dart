import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tree_router/srs/base/tree_router_controller.dart';
import 'package:tree_router/srs/tree/tree_route.dart';
import 'package:tree_router/srs/tree/route_value.dart';

class RootTreeRouterController extends ChangeNotifier
    with TreeRouterControllerMixin {
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

  final Map<Object, TreeRoute> _routeMap = {};

  void navigate(RouteValue target) {
    final TreeRoute? targetRoute = _routeMap[target.key];

    if (targetRoute == null) {
      throw 'todo';
    }

    root = targetRoute.createBuilderRec(
      value: target,
    );

    notifyListeners();
  }

  void pop() {
    final target = popInternal();

    if (target == null) {
      SystemNavigator.pop();
    } else {
      navigate(target);
    }
  }

  @override
  TreeRouterControllerMixin? get parent => null;
}
