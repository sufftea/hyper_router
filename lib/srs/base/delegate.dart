import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:star/srs/base/nested_navigator.dart';
import 'package:star/srs/base/star.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/value/route_value.dart';

class StarRouterDelegate extends RouterDelegate<RouteNode> with ChangeNotifier {
  StarRouterDelegate({
    required this.routerConfig,
  }) {
    routerConfig.rootController.state.addListener(notifyListeners);
  }

  @override
  void dispose() {
    super.dispose();

    routerConfig.rootController.state.removeListener(notifyListeners);
  }

  final Star routerConfig;

  @override
  Widget build(BuildContext context) {
    final rootController = routerConfig.rootController;

    return InheritedFractalRouter(
      router: routerConfig,
      child: InheritedNavigatorNode(
        node: rootController.rootNavigatorNode,
        child: Builder(builder: (context) {
          return Navigator(
            pages: rootController.state.stack.createPages(context),
            key: rootController.rootNavigatorNode.key,
            onPopPage: (route, result) {
              rootController.popRoute(result);
              return false;
            },
          );
        }),
      ),
    );
  }

  @override
  Future<bool> popRoute() async {
    routerConfig.rootController.pop();
    return SynchronousFuture(true);
  }

  @override
  RouteNode<RouteValue>? get currentConfiguration =>
      routerConfig.rootController.stack;

  @override
  Future<void> setNewRoutePath(RouteNode<RouteValue> configuration) async {
    routerConfig.rootController.state.updateSilent(configuration);

    return SynchronousFuture(null);
  }
}
