import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fractal_router/srs/value/route_value.dart';

abstract class Froute<T extends RouteValue> {
  Froute({
    this.children = const [],
  }) {
    for (final child in children) {
      child.parent = this;
    }
  }

  final List<Froute> children;
  late final Froute? parent;

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

  PageBuilder last() {
    PageBuilder curr = this;

    while (curr.next != null) {
      curr = curr.next!;
    }

    return curr;
  }

  PageBuilder? pop();
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

extension TreeRouteX<T extends RouteValue> on Froute<T> {
  void forEach(void Function(Froute r) action) {
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
