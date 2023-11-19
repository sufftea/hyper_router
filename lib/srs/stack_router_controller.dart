import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/destination/destination.dart';
import 'package:flutter_stack_router/srs/internal/destination_mapper.dart';
import 'package:flutter_stack_router/srs/route_stack.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';

class StackRouterController extends ChangeNotifier {
  StackRouterController({
    required DestinationMapper mapper,
    RouteStack? initialStack,
    DestinationValue? initialDestination,
  }) : _mapper = mapper {
    _stack = initialStack ?? _createStackFromTarget(initialDestination!, []);
  }

  final DestinationMapper _mapper;
  late RouteStack _stack;

  RouteStack get stack => _stack;
  set stack(RouteStack value) {
    _stack = value;
    notifyListeners();
  }

  void navigate(DestinationValue destinationValue) {
    stack = _createStackFromTarget(destinationValue);
  }

  /// Traverses the tree and returns a stack that leads to [target]
  RouteStack _createStackFromTarget(
    DestinationValue target, [
    List<DestinationValue>? currStack,
  ]) {
    Destination? curr = _mapper.findDestination(target);

    var path = <Destination>[];
    while (curr != null) {
      path.add(curr);
      curr = curr.parent;
    }

    List<DestinationValue?> stack = (currStack ?? _stack.list).padded(
      path.length,
      null,
    );

    final reversedMap = _zip(path.toList(), stack.reversed.toList());

    var res = <DestinationValue>[];
    for (final (destination!, value) in reversedMap) {
      res = destination.visit(currentValue: value, onTop: res);
    }

    return RouteStack(res);
  }

  static Iterable<(T?, U?)> _zip<T, U>(List<T> a, List<U> b) {
    return Iterable.generate(
      max(a.length, b.length),
      (index) {
        return (
          index < a.length ? a[index] : null,
          index < b.length ? b[index] : null,
        );
      },
    );
  }
}

extension ListX<T> on List<T> {
  List<U> padded<U>(int length, U padding) {
    return cast<U>() +
        List<U>.generate(length - this.length, (index) => padding);
  }
}
