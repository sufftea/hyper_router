// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  Object get key;

  PageBuilder createBuilder({
    PageBuilder? next,
    T? value,
  });
}

class PageBuilder {
  PageBuilder({
    required this.next,
    required this.buildPage,
    required this.value,
  });

  final PageBuilder? next;
  final Page Function(BuildContext context) buildPage;
  final RouteValue value;

  bool get isTop => next == null;

  List<Page> createPages(BuildContext context) {
    return [
      buildPage(context),
      ...next?.createPages(context) ?? [],
    ];
  }

  PageBuilder asTop() {
    return PageBuilder(
      next: null,
      buildPage: buildPage,
      value: value,
    );
  }
}

extension TreeRouteX<T extends RouteValue> on TreeRoute<T> {
  void forEach(void Function(TreeRoute r) action) {
    action(this);
    for (final child in children) {
      child.forEach(action);
    }
  }

  PageBuilder createBuilderRec({
    PageBuilder? next,
    T? value,
  }) {
    final myBuilder = createBuilder(
      next: next,
      value: value,
    );

    if (parent case final parent?) {
      return parent.createBuilderRec(
        next: myBuilder,
        value: null,
      );
    } else {
      return myBuilder;
    }
  }
}
