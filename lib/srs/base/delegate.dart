import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fractal_router/srs/base/controller.dart';
import 'package:fractal_router/srs/base/fractal_router.dart';
import 'package:fractal_router/srs/base/nested_navigator.dart';

class FractalRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  FractalRouterDelegate({
    required this.rootController,
    required this.routerConfig,
  });

  final RootFractalController rootController;
  final FractalRouter routerConfig;

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
            return Navigator(
              pages: rootController.createPages(context),
              key: rootController.rootNavigatorNode.key,
              onPopPage: (route, result) {
                rootController.popInternalState();
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
    return SynchronousFuture(rootController.pop());
  }

  @override
  Future<void> setNewRoutePath(Object configuration) {
    throw UnimplementedError();
  }
}
