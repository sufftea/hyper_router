import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/tree/route_value.dart';

abstract class MyRoute<T extends RouteValue> {
  MyRoute({
    this.children = const [],
  }) {
    for (final child in children) {
      child.parent = this;
    }
  }

  final List<MyRoute> children;
  late final MyRoute? parent;

  set value(T value);
  T get value;

  MyRoute? next;

  Object get key;

  Widget buildScreen(BuildContext context);

  Page buildPage(BuildContext context) {
    return MaterialPage(child: buildScreen(context));
  }

  static List<Page> createPages(BuildContext context, MyRoute root) {
    final pages = <Page>[];

    MyRoute? r = root;
    while (r != null) {
      pages.add(r.buildPage(context));
      r = r.next;
    }

    return pages;
  }
}
