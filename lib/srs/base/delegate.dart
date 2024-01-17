import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fractal_router/srs/base/controller.dart';
import 'package:fractal_router/srs/base/nested_navigator.dart';
import 'package:fractal_router/srs/base/router.dart';

class FractalRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  FractalRouterDelegate({
    required this.rootController,
    required this.routerConfig,
    required this.redirect,
  });

  final FractalRoot rootController;
  final FractalRouter routerConfig;
  final RedirectCallback redirect;

  @override
  Widget build(BuildContext context) {
    return InheritedFractalRouter(
      router: routerConfig,
      rootController: rootController,
      child: InheritedNavigatorNode(
        node: rootController.rootNavigatorNode,
        child: AnimatedBuilder(
          animation: rootController,
          builder: (context, child) {
            if (redirect(context, rootController.stack) case final target?) {
              rootController.navigateSilent(target);
            }
            
            return Builder(builder: (context) {
              return Navigator(
                pages: rootController.createPages(context),
                key: rootController.rootNavigatorNode.key,
                onPopPage: (route, result) {
                  rootController.popRoute();
                  return false;
                },
              );
            });
          },
        ),
      ),
    );
  }

  @override
  Future<bool> popRoute() async {
    return SynchronousFuture(rootController.pop());
  }

  @override
  Future<void> setNewRoutePath(Object configuration) {
    throw UnimplementedError();
  }
}
