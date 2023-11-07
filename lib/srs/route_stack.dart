import 'dart:collection';

import 'package:flutter/material.dart';

/// Wrapper around a [List] to prevent mutation.
class RouteStack {
  RouteStack(this._list);

  final List<Object> _list;
  UnmodifiableListView<Object> get list => UnmodifiableListView(_list);

  RouteStack pushed(Object value) {
    return RouteStack([..._list, value]);
  }

  RouteStack popped() {
    if (_list.isEmpty) {
      return RouteStack(_list);
    }

    return RouteStack(_list.sublist(0, _list.length - 1));
  }

  RouteStack root() {
    if (list.isEmpty) {
      return RouteStack(_list);
    }

    return RouteStack([_list.first]);
  }

  @override
  bool operator ==(Object other) {
    return other is RouteStack && other._list == _list;
  }

  @override
  int get hashCode => _list.hashCode;
}

class InheritedRouteStack extends InheritedWidget {
  const InheritedRouteStack({
    required this.stack,
    required super.child,
    super.key,
  });

  final RouteStack stack;

  @override
  bool updateShouldNotify(InheritedRouteStack oldWidget) {
    return oldWidget.stack != stack;
  }
}
