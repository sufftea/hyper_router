import 'package:flutter/material.dart';
import 'package:tea_router/srs/tree/route_value.dart';

abstract class TeaRoute<T extends RouteValue> {
  TeaRoute({
    this.children = const [],
  }) {
    for (final child in children) {
      child.parent = this;
    }
  }

  final List<TeaRoute> children;
  late final TeaRoute? parent;

  set value(T value);
  T get value;

  /// The route that should be displayed above this one.
  TeaRoute? next;

  Object get key;

  List<Page> createPages(BuildContext context);
}
