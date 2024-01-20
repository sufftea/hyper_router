import 'package:snowflake_route/srs/value/route_value.dart';

class RouteName extends RouteValue {
  const RouteName(this.name);
  final String name;

  @override
  Object get key => name;
}