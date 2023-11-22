import 'package:flutter/material.dart';
import 'package:tea_router/srs/tree/tea_route.dart';
import 'package:tea_router/srs/tree/route_value.dart';

class ValueRoute<T extends RouteValue> extends TeaRoute<T> {
  ValueRoute({
    required this.screenBuilder,
    super.children,
    T? defaultValue,
    this.pageBuilder,
  }) : _value = defaultValue;

  /// E.g. you can use [CustomPageBuilder] for a custom transition
  final Page Function(BuildContext context, Widget child)? pageBuilder;
  final Widget Function(BuildContext context, T value) screenBuilder;


  @override
  T get value => _value ?? (throw 'todo: default value not provided');
  T? _value;
  @override
  set value(T value) {
    _value = value;
  }

  @override
  Object get key => T;

  @override
  Widget buildScreen(BuildContext context) {
    return screenBuilder(context, value);
  }

  @override
  Page buildPage(BuildContext context) {
    return pageBuilder?.call(context, buildScreen(context)) ??
        super.buildPage(context);
  }

  

  // @override
  // void activate(RouteValue? value, MyRoute? next) {
  //   value ??= _currValue;

  //   if (value == null || value.key != key || value is! T) {
  //     throw "todo: value type mismatch";
  //   }

  //   _currValue = value;
  //   this.next = next;
  // }
}
