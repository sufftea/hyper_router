import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fractal_router/srs/base/controller.dart';
import 'package:fractal_router/srs/base/nested_navigator.dart';
import 'package:fractal_router/srs/base/root_navigation_stack.dart';
import 'package:fractal_router/srs/base/router.dart';

class FractalRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  FractalRouterDelegate({
    required this.routerConfig,
    required this.redirect,
  });

  final FractalRouter routerConfig;
  final RedirectCallback redirect;

  @override
  Widget build(BuildContext context) {
    final rootController = routerConfig.rootController;

    return InheritedFractalRouter(
      router: routerConfig,
      child: InheritedNavigatorNode(
        node: rootController.rootNavigatorNode,
        child: RootNavigationStack(
          redirect: redirect,
          rootController: rootController,
          builder: (context, pages) {
            return Navigator(
              pages: pages,
              key: rootController.rootNavigatorNode.key,
              onPopPage: (route, result) {
                rootController.popRoute(result);
                return false;
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Future<bool> popRoute() async {
    return SynchronousFuture(routerConfig.rootController.pop());
  }

  @override
  Future<void> setNewRoutePath(Object configuration) {
    throw UnimplementedError();
  }
}
