import 'package:snowflake_route/srs/value/route_value.dart';

abstract class FlakeController {
  void navigate(RouteValue target, [Set<RouteValue> values = const {}]);
  void pop<T>([T? value]);

  Future push(RouteValue target);
}

