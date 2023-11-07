import 'package:flutter/material.dart';

/// Builds a route with the value of type T, when such is added to the stack.
abstract class Destination<T> {
  const Destination();

  Type get valueType => T;

  Widget buildScreen(BuildContext context, T value);

  Page buildPage(BuildContext context, {required Widget child}) {
    return MaterialPage(child: child);
  }
}

typedef ScreenBuilder<T> = Widget Function(BuildContext context, T value);
typedef PageBuilder = Page Function(BuildContext context, Widget child);

class ScreenDestination<T> extends Destination<T> {
  ScreenDestination({
    required this.screenBuilder,
    this.pageBuilder,
  });

  final ScreenBuilder<T> screenBuilder;

  /// You can use [CustomPageBuilder] for a custom transition
  final PageBuilder? pageBuilder;

  @override
  Widget buildScreen(BuildContext context, T value) {
    return screenBuilder(context, value);
  }

  @override
  Page buildPage(BuildContext context, {required Widget child}) {
    return pageBuilder?.call(context, child) ??
        super.buildPage(
          context,
          child: child,
        );
  }
}
