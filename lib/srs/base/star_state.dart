import 'package:flutter/material.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/value/route_value.dart';

class StarState extends ChangeNotifier {
  StarState({required this.redirect});

  final RouteNode Function(RouteNode stack) redirect;

  RouteNode? _stack;
  RouteNode get stack => _stack!;
  set stack(RouteNode value) {
    _stack = redirect(value);
    notifyListeners();
  }

  void updateSilent(RouteNode value) {
    _stack = redirect(value);
  }

  Map<Object, RouteValue> get values {
    final result = <Object, RouteValue>{};

    _stack?.forEach((builder) {
      result[builder.value.key] = builder.value;
    });

    return result;
  }
}
