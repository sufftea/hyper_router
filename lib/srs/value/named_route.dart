import 'package:flutter/material.dart';
import 'package:fractal_router/srs/route/value_route.dart';
import 'package:fractal_router/srs/value/route_value.dart';

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
  }) : super(
          screenBuilder: (context, value) => screenBuilder(context),
          defaultValue: name,
        );

  final RouteName name;

  @override
  Object get key => name.key;

}
