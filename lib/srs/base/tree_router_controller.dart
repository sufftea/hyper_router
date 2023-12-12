import 'package:flutter/material.dart';
import 'package:tree_router/srs/tree/route_value.dart';
import 'package:tree_router/srs/tree/tree_route.dart';

mixin TreeRouterControllerMixin {
  TreeRouterControllerMixin? get parent;
  TreeRouterControllerMixin? _next;

  PageBuilder? root;

  List<Page> createPages(BuildContext context) {
    return root?.createPages(context) ?? [];
  }

  RouteValue? popInternal() {
    if (_next?.popInternal() case final value?) {
      return value;
    }

    if (root case final root?) {
      return root.popped()?.value;
    }

    return null;
  }

  void takePriority() {
    _next = null;
    parent?.deferTo(this);
  }

  void deferTo(TreeRouterControllerMixin next) {
    _next = next;
  }
}

extension _PageBuilderX on PageBuilder {
  PageBuilder? popped() {
    if (next case final next?) {
      if (next.isTop) {
        return this;
      }

      return next.popped();
    }

    return null;
  }
}
