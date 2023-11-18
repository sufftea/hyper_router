import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';

/// Wrapper around a [List] to prevent mutation.
class RouteStack {
  RouteStack(this._list);

  final List<DestinationValue> _list;
  UnmodifiableListView<DestinationValue> get list => UnmodifiableListView(_list);

  RouteStack pushed(DestinationValue value) {
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

