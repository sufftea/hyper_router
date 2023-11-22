import 'package:tea_router/srs/base/tea_router_delegate.dart';
import 'package:tea_router/srs/tree/tea_route.dart';
import 'package:tea_router/srs/tree/route_value.dart';

class TeaRouterController extends RouterDelegateNotifier {
  TeaRouterController({
    required List<TeaRoute> roots,
    required RouteValue initialRoute,
  }) {
    for (final r in roots) {
      r.forEach((r) {
        _routeMap[r.key] = r;
      });
    }

    navigate(initialRoute);
  }

  final Map<Object, TeaRoute> _routeMap = {};
  @override
  late TeaRoute stackRoot;

  void navigate(RouteValue target) {
    TeaRoute? r = _routeMap[target.key];
    TeaRoute? prevR;
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

extension _MyRouteX<T extends RouteValue> on TeaRoute<T> {
  void forEach(void Function(TeaRoute r) action) {
    action(this);
    for (final child in children) {
      child.forEach(action);
    }
  }
}
