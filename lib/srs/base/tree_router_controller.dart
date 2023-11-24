import 'package:tree_router/srs/base/tree_router_delegate.dart';
import 'package:tree_router/srs/tree/tree_route.dart';
import 'package:tree_router/srs/tree/route_value.dart';

class TreeRouterController extends RouterDelegateNotifier {
  TreeRouterController({
    required List<TreeRoute> roots,
    required RouteValue initialRoute,
  }) {
    for (final r in roots) {
      r.forEach((r) {
        _routeMap[r.key] = r;
      });
    }

    navigate(initialRoute);
  }

  final Map<Object, TreeRoute> _routeMap = {};
  @override
  late TreeRoute stackRoot;

  void navigate(RouteValue target) {
    TreeRoute? r = _routeMap[target.key];
    TreeRoute? prevR;
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

  void pop() {
    
  }
}

extension _MyRouteX<T extends RouteValue> on TreeRoute<T> {
  void forEach(void Function(TreeRoute r) action) {
    action(this);
    for (final child in children) {
      child.forEach(action);
    }
  }
}
