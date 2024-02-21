import 'package:hyper_router/srs/value/route_value.dart';

class RouteName extends RouteValue {
  const RouteName(this.name);
  final String name;

  @override
  Object get key => name;

  @override
  String toString() {
    return "RouteName('$name')";
  }
}