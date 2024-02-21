import 'package:hyper_router/srs/route/hyper_route.dart';
import 'package:hyper_router/srs/value/route_value.dart';

abstract class HyperController {
  Future navigate(RouteValue target, [Set<RouteValue> values = const {}]);
  void pop<T>([T? value]);

  RouteNode get stack;
}

