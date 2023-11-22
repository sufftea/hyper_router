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

  TeaRoute? next;

  Object get key;

  Widget buildScreen(BuildContext context);

  Page buildPage(BuildContext context) {
    return MaterialPage(child: buildScreen(context));
  }

  static List<Page> createPages(BuildContext context, TeaRoute root) {
    final pages = <Page>[];

    TeaRoute? r = root;
    while (r != null) {
      pages.add(r.buildPage(context));
      r = r.next;
    }

    return pages;
  }
}
