import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/value/route_value.dart';

abstract class StarController {
  Future navigate(RouteValue target, [Set<RouteValue> values = const {}]);
  void pop<T>([T? value]);

  RouteNode get stack;
}

