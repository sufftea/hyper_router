import 'dart:async';

import 'package:flutter/material.dart';

import 'package:star/srs/value/route_value.dart';

abstract class StarRoute<T extends RouteValue> {
  StarRoute({
    this.children = const [],
  }) {
    for (final child in children) {
      child.parent = this;
    }
  }

  final List<StarRoute> children;
  late final StarRoute? parent;

  Object get key;

  RouteNode createNode({
    RouteNode? next,
    T? value,
  });
}

abstract class RouteNode<T extends RouteValue> {
  RouteNode? get next;
  T get value;
  Object get key => value.key;
  final popCompleter = Completer();

  bool get isTop => next == null;

  List<Page> createPages(BuildContext context);

  RouteNode? pop();

  RouteNode last() {
    RouteNode curr = this;

    while (curr.next != null) {
      curr = curr.next!;
    }

    return curr;
  }

  bool containsNode(Object key) {
    if (this.key == key) {
      return true;
    } else if (next case final next?) {
      return next.containsNode(key);
    }

    return false;
  }
}

extension RouteNodeX on RouteNode {
  void forEach(void Function(RouteNode builder) action) {
    RouteNode? curr = this;
    while (curr != null) {
      action(curr);
      curr = curr.next;
    }
  }
}

extension TreeRouteX<T extends RouteValue> on StarRoute<T> {
  void forEach(void Function(StarRoute r) action) {
    action(this);
    for (final child in children) {
      child.forEach(action);
    }
  }

  RouteNode createNodeRec({
    RouteNode? next,
    required Map<Object, RouteValue> values,
  }) {
    final node = createNode(
      next: next,
      value: values[key] as T?,
    );

    if (parent case final parent?) {
      return parent.createNodeRec(
        next: node,
        values: values,
      );
    } else {
      return node;
    }
  }
}
