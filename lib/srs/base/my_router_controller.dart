import 'package:flutter_stack_router/srs/base/my_router_delegate.dart';
import 'package:flutter_stack_router/srs/tree/my_route.dart';
import 'package:flutter_stack_router/srs/tree/route_value.dart';

class MyRouterController extends RouterDelegateNotifier {
  MyRouterController({
    required List<MyRoute> roots,
    required RouteValue initialRoute,
  }) {
    for (final r in roots) {
      r.forEach((r) {
        _routeMap[r.key] = r;
      });
    }

    navigate(initialRoute);
  }

  final Map<Object, MyRoute> _routeMap = {};
  @override
  late MyRoute stackRoot;

  void navigate(RouteValue target) {
    MyRoute? r = _routeMap[target.key];
    MyRoute? prevR;
    RouteValue? v = target;
    while (r != null) {
      r.next = prevR;

      if (v != null) {
        if (v.key != r.key) {
          throw 'todo';
        }
        r.value = v;
      }

      prevR = r;
      r = r.parent;
      v = null;
    }

    stackRoot = prevR!;

    notifyListeners();
  }
}

extension _MyRouteX<T extends RouteValue> on MyRoute<T> {
  void forEach(void Function(MyRoute r) action) {
    action(this);
    for (final child in children) {
      child.forEach(action);
    }
  }
}
