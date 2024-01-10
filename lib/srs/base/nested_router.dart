import 'package:flutter/material.dart';
import 'package:fractal_router/srs/base/fractal_router.dart';

class NestedRouter extends StatelessWidget {
  const NestedRouter({
    required this.pages,
    super.key,
  });

  final List<Page> pages;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: pages,
      onPopPage: (route, result) {
        FractalRouter.of(context).pop();
        return false;
      },
    );
  }
}
