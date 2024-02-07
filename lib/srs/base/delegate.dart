import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:star/srs/base/nested_navigator.dart';
import 'package:star/srs/base/root_star_controller.dart';
import 'package:star/srs/base/star.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/value/route_value.dart';

class StarRouterDelegate extends RouterDelegate<RouteNode> with ChangeNotifier {
  StarRouterDelegate({
    required this.routerConfig,
    required this.initialRoute,
  }) {
    routerConfig.rootController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    super.dispose();

    routerConfig.rootController.removeListener(notifyListeners);
  }

  final RouteValue initialRoute;
  final Star routerConfig;

  @override
  Widget build(BuildContext context) {
    final rootController = routerConfig.rootController;
    return InheritedFractalRouter(
      router: routerConfig,
      child: RedirectWatcher(
        child: InheritedNavigatorNode(
          node: rootController.rootNavigatorNode,
          child: Builder(builder: (context) {
            return Navigator(
              pages: rootController.stack.createPages(context).toList(),
              key: rootController.rootNavigatorNode.key,
              onPopPage: (route, result) {
                rootController.popRoute(result);
                return false;
              },
            );
          }),
        ),
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
    routerConfig.rootController.setStack(configuration, notify: false);

    return SynchronousFuture(null);
  }
}
