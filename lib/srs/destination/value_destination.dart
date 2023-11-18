import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/destination/destination.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';

class ValueDestination<T extends DestinationValue> extends Destination<T> {
  ValueDestination({
    required this.screenBuilder,
    this.defaultValue,
    this.pageBuilder,
    super.children = const [],
  });

  final Widget Function(BuildContext context, T value) screenBuilder;
  final T? defaultValue;

  /// E.g. you can use [CustomPageBuilder] for a custom transition
  final Page Function(BuildContext context, Widget child)? pageBuilder;

  @override
  Widget buildScreen(BuildContext context, T value) {
    return screenBuilder(context, value);
  }

  @override
  Page buildPage(BuildContext context, T value) {
    return pageBuilder?.call(context, buildScreen(context, value)) ??
        super.buildPage(context, value);
  }

  @override
  List<DestinationValue> visit({
    required T? currentValue,
    required Iterable<DestinationValue> onTop,
  }) {
    final defaultValue = this.defaultValue;
    if (defaultValue == null) {
      throw 'todo';
    }

    return [
      currentValue ?? defaultValue,
      ...onTop,
    ];
  }
}
