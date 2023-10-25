import 'package:flutter/material.dart';
import 'package:flutter_stack_router/destination.dart';
import 'package:flutter_stack_router/route_stack.dart';

class DestinationMapper {
  DestinationMapper(
    List<Destination> destinations,
  ) : _destinations = {
          for (final d in destinations) d.valueType: d,
        };

  final Map<Type, Destination> _destinations;

  List<Page> mapStack(BuildContext context, RouteStack stack) {
    int i = 1;

    return stack.list.map((value) {
      final destination = valueToDestination(value);

      final currStack = RouteStack(stack.list.sublist(0, i));
      i++;

      // TODO: Material/Cupertino setting
      // TODO: test wrapping in builder (prevent building )
      return MaterialPage(
        child: destination.buildScreenWrapped(context, value, currStack),
      );
    }).toList();
  }

  Destination valueToDestination(Object value) {
    final destination = _destinations[value.runtimeType];

    if (destination == null) {
      throw StateError(
        'Destination for ${value.runtimeType} is not provided',
      );
    }

    return destination;
  }
}
