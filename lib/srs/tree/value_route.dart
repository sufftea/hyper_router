import 'package:flutter/material.dart';
import 'package:tree_router/srs/tree/tree_route.dart';
import 'package:tree_router/srs/tree/route_value.dart';

class ValueRoute<T extends RouteValue> extends TreeRoute<T> {
  ValueRoute({
    required this.screenBuilder,
    super.children,
    this.defaultValue,
    this.pageBuilder,
  });

  /// E.g. you can use [CustomPageBuilder] for a custom transition
  final Page Function(BuildContext context, Widget child)? pageBuilder;
  final Widget Function(BuildContext context, T value) screenBuilder;

  final T? defaultValue;

  @override
  Object get key => T;

  @override
  PageBuilder createBuilder({PageBuilder? next, T? value}) {
    value ??= defaultValue;

    if (value == null) {
      throw 'todo';
    }

    return PageBuilder(
      buildPage: (context) => _buildPage(context, value!),
      next: next,
      value: value,
    );
  }

  Page _buildPage(BuildContext context, T value) {
    final screen = screenBuilder(context, value);

    if (pageBuilder != null) {
      return pageBuilder!.call(context, screen);
    }

    return MaterialPage(child: screen);
  }
}
