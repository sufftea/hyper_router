import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:star/srs/base/nested_navigator.dart';
import 'package:star/srs/base/root_navigation_stack.dart';
import 'package:star/srs/base/star.dart';

class FlakeRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  FlakeRouterDelegate({
    required this.routerConfig,
    required this.redirect,
  });

  final Star routerConfig;
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
    routerConfig.rootController.pop(); 
    return SynchronousFuture(true);
  }

  @override
  Future<void> setNewRoutePath(Object configuration) {
    throw UnimplementedError();
  }
}
