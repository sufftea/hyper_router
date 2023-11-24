import 'package:flutter/material.dart';
import 'package:tree_router/srs/tree/route_value.dart';

abstract class TreeRoute<T extends RouteValue> {
  TreeRoute({
    this.children = const [],
  }) {
    for (final child in children) {
      child.parent = this;
    }
  }

  final List<TreeRoute> children;
  late final TreeRoute? parent;

  set value(T value);
  T get value;

  /// The route that should be displayed above this one.
  TreeRoute? next;

  Object get key;

  List<Page> createPages(BuildContext context);
}
