import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fractal_router/srs/base/fractal_controller.dart';
import 'package:fractal_router/srs/base/fractal_router.dart';

class FractalRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  FractalRouterDelegate({
    required this.controller,
    required this.routerConfig,
  });

  final FractalController controller;
  final FractalRouter routerConfig;
  List<Page> _pages = [];

  @override
  Widget build(BuildContext context) {
    return InheritedFractalRouter(
      router: routerConfig,
      child: InheritedFractalController(
        controller: controller,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            _pages = controller.createPages(context);

            return Navigator(
              pages: _pages,
              onPopPage: (route, result) {
                controller.pop();
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
    controller.pop();

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
