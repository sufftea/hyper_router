import 'package:flutter/material.dart';
import 'package:tree_router/srs/tree/value_route.dart';
import 'package:tree_router/srs/tree/route_value.dart';

class RouteName extends RouteValue {
  const RouteName(this.name);
  final String name;

  @override
  Object get key => name;
}

class NamedRoute extends ValueRoute<RouteName> {
  NamedRoute({
    required Widget Function(BuildContext context) screenBuilder,
    required this.name,
    super.children,
    super.pageBuilder,
    super.defaultValue,
  }) : super(
          screenBuilder: (context, value) => screenBuilder(context),
        );

  final RouteName name;

  @override
  Object get key => name.key;

  @override
  RouteName get value => name;
  @override
  set value(RouteName value) {}
}
