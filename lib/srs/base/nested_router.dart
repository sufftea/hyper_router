import 'package:flutter/material.dart';
import 'package:tree_router/srs/base/tree_router.dart';

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
        TreeRouter.of(context).pop();
        return false;
      },
    );
  }
}
