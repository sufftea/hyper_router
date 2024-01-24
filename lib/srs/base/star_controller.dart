import 'package:star/srs/value/route_value.dart';

abstract class StarController {
  void navigate(RouteValue target, [Set<RouteValue> values = const {}]);
  void pop<T>([T? value]);

  Future push(RouteValue target);
}

