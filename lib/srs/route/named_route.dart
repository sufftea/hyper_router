
import 'package:flutter/material.dart';
import 'package:snowflake_route/snowflake_route.dart';

class NamedRoute extends ValueRoute<RouteName> {
  NamedRoute({
    required Widget Function(BuildContext context) screenBuilder,
    required this.name,
    super.pageBuilder,
    super.children,
  }) : super(
          screenBuilder: (context, value) => screenBuilder(context),
          defaultValue: name,
        );

  final RouteName name;

  @override
  Object get key => name.key;

}
