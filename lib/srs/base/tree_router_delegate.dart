import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tree_router/srs/base/root_tree_router_controller.dart';
import 'package:tree_router/srs/base/tree_router.dart';

class TreeRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  TreeRouterDelegate({
    required this.rootController,
    required this.routerConfig,
  });

  final RootTreeRouterController rootController;
  final TreeRouter routerConfig;
  List<Page> _pages = [];

  @override
  Widget build(BuildContext context) {
    return InheritedTreeRouter(
      router: routerConfig,
      child: InheritedRouterController(
        controller: rootController,
        child: AnimatedBuilder(
          animation: rootController,
          builder: (context, child) {
            _pages = rootController.createPages(context);

            return Navigator(
              pages: _pages,
              onPopPage: (route, result) {
                rootController.pop();
                return true;
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Future<bool> popRoute() async {
    rootController.pop();

    return SynchronousFuture(true);
  }

  @override
  Future<void> setNewRoutePath(Object configuration) {
    throw UnimplementedError();
  }

  // @override
  // Future<void> setNewRoutePath(RouteStack configuration) {
  //   controller.stack = configuration;
  //   return SynchronousFuture(null);
  // }

  // @override
  // Future<void> setInitialRoutePath(RouteStack configuration) {
  //   return setNewRoutePath(configuration);
  // }
}
