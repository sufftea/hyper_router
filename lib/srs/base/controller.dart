import 'package:fractal_router/srs/value/route_value.dart';

abstract class FractalController {
  void navigate(RouteValue target, [Set<RouteValue> values = const {}]);
  void pop<T>([T? value]);

  Future push(RouteValue target);
}

