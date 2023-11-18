import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/destination/destination.dart';
import 'package:flutter_stack_router/srs/route_stack.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';

class DestinationMapper {
  DestinationMapper({
    required this.roots,
  }) {
    for (final child in roots) {
      child.forEach((d) {
        _destinations[d.key] = d;
      });
    }
  }

  final _destinations = <Object, Destination>{};
  final List<Destination> roots;

  List<Page> mapStack(BuildContext context, RouteStack stack) {
    final result = <Page>[];
    var currChildren = roots;

    for (final value in stack.list) {
      for (final destination in currChildren) {
        if (destination.acceptsValue(value)) {
          result.add(destination.buildPage(context, value));
          currChildren = destination.children;
        }
      }
    }

    return result;
  }

  Destination findDestination(DestinationValue value) {
    final result = _destinations[value];

    if (result == null) {
      throw 'todo';
    }

    return result;
  }
}

extension _DestinationX<T extends DestinationValue> on Destination<T> {
  void forEach(void Function(Destination d) visitor) {
    visitor(this);
    for (final child in children) {
      child.forEach(visitor);
    }
  }
}
