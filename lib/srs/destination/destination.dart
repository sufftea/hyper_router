import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';

/// Builds a route with the value of type T, when such is added to the stack.
abstract class Destination<T extends DestinationValue> {
  Destination({
    required this.children,
  }) {
    for (final child in children) {
      child.parent = this;
    }
  }

  List<Destination> children;
  late final Destination? parent;

  Widget buildScreen(BuildContext context, T value);

  Page buildPage(BuildContext context, T value) {
    // TODO: conditionally set CupertinoPage
    return MaterialPage(child: buildScreen(context, value));
  }

  Object get key => T;

  bool acceptsValue(DestinationValue value) => value.key == key;

  List<DestinationValue> visit({
    required T? currentValue,
    required Iterable<DestinationValue> onTop,
  });

  T? get defaultValue => null;

  /// Returns `null` if wants to be popped, otherwise returns a new value that
  /// will replace it.
  T? onPop(T currValue) => null;
}
