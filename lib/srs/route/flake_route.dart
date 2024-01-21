import 'dart:async';

import 'package:flutter/material.dart';

import 'package:snowflake_route/srs/value/route_value.dart';

abstract class FlakeRoute<T extends RouteValue> {
  FlakeRoute({
    this.children = const [],
  }) {
    for (final child in children) {
      child.parent = this;
    }
  }

  final List<FlakeRoute> children;
  late final FlakeRoute? parent;

  Object get key;

  PageBuilder createBuilder({
    PageBuilder? next,
    T? value,
  });
}

abstract class PageBuilder<T extends RouteValue> {
  PageBuilder? get next;
  T get value;
  Object get key => value.key;
  final popCompleter = Completer();

  bool get isTop => next == null;

  List<Page> createPages(BuildContext context);

  PageBuilder? pop();

  PageBuilder last() {
    PageBuilder curr = this;

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

extension PageBuilderX on PageBuilder {
  void forEach(void Function(PageBuilder builder) action) {
    PageBuilder? curr = this;
    while (curr != null) {
      action(curr);
      curr = curr.next;
    }
  }
}

extension TreeRouteX<T extends RouteValue> on FlakeRoute<T> {
  void forEach(void Function(FlakeRoute r) action) {
    action(this);
    for (final child in children) {
      child.forEach(action);
    }
  }

  PageBuilder createBuilderRec({
    PageBuilder? next,
    required Map<Object, RouteValue> values,
  }) {
    final myBuilder = createBuilder(
      next: next,
      value: values[key] as T?,
    );

    if (parent case final parent?) {
      return parent.createBuilderRec(
        next: myBuilder,
        values: values,
      );
    } else {
      return myBuilder;
    }
  }
}
