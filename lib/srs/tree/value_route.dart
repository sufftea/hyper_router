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

  /// you can use this to customize transition
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

    return ValuePageBuilder(
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

class ValuePageBuilder extends PageBuilder {
  ValuePageBuilder({
    required this.next,
    required this.value,
    required this.buildPage,
  });

  final Page Function(BuildContext context) buildPage;

  @override
  final PageBuilder<RouteValue>? next;

  @override
  final RouteValue value;

  @override
  List<Page> createPages(BuildContext context) {
    return [
      buildPage(context),
      ...next?.createPages(context) ?? [],
    ];
  }

  @override
  PageBuilder<RouteValue>? pop() {
    if (next case final next?) {
      return ValuePageBuilder(
        next: next.pop(),
        value: value,
        buildPage: buildPage,
      );
    } else {
      return null;
    }
  }
}
