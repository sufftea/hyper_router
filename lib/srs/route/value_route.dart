import 'package:flutter/material.dart';
import 'package:star/srs/base/star_error.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/value/route_value.dart';

class ValueRoute<T extends RouteValue> extends StarRoute<T> {
  ValueRoute({
    required this.screenBuilder,
    this.defaultValue,
    this.pageBuilder,
    super.children,
  });

  final Page Function(BuildContext context, Widget child)? pageBuilder;
  final Widget Function(BuildContext context, T value) screenBuilder;

  final T? defaultValue;

  @override
  Object get key => T;

  @override
  RouteNode createNode({RouteNode? next, T? value}) {
    value ??= defaultValue;

    if (value == null) {
      throw StarError("No value provided for ValueRoute<$key>");
    }

    return ValueNode(
      buildPage: (context) => buildPage(context, value!),
      next: next,
      value: value,
    );
  }

  Page buildPage(BuildContext context, T value) {
    final screen = screenBuilder(context, value);

    if (pageBuilder != null) {
      return pageBuilder!.call(context, screen);
    }

    return MaterialPage(child: screen);
  }
}

class ValueNode extends RouteNode {
  ValueNode({
    required this.next,
    required this.value,
    required this.buildPage,
  });

  final Page Function(BuildContext context) buildPage;

  @override
  final RouteNode<RouteValue>? next;

  @override
  final RouteValue value;

  @override
  List<Page> createPages(BuildContext context) {
    final page = buildPage(context);

    return [
      page,
      ...next?.createPages(context) ?? [],
    ];
  }

  @override
  RouteNode<RouteValue>? pop() {
    if (next case final next?) {
      return ValueNode(
        next: next.pop(),
        value: value,
        buildPage: buildPage,
      );
    } else {
      return null;
    }
  }
}
