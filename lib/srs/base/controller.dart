import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractal_router/srs/base/nested_navigator.dart';
import 'package:fractal_router/srs/tree/froute.dart';
import 'package:fractal_router/srs/tree/route_value.dart';

class RootFractalController extends ChangeNotifier {
  RootFractalController({
    required List<Froute> roots,
    required RouteValue initialRoute,
    required RootBackButtonDispatcher dispatcher,
  }) {
    for (final r in roots) {
      r.forEach((r) {
        _routeMap[r.key] = r;
      });
    }

    navigate(initialRoute);
  }

  PageBuilder? root;

  final rootNavigatorNode = NavigatorNode(GlobalKey<NavigatorState>());

  final Map<Object, Froute> _routeMap = {};

  void navigate(RouteValue target, [Set<RouteValue> values = const {}]) {
    final Froute? targetRoute = _routeMap[target.key];

    if (targetRoute == null) {
      throw 'todo';
    }

    final valuesMap = <Object, RouteValue>{
      for (final v in values) v.key: v,
    };
    root?.forEach((builder) {
      valuesMap[builder.value.key] = builder.value;
    });
    valuesMap[target.key] = target;

    root = targetRoute.createBuilderRec(values: valuesMap);

    notifyListeners();
  }

  bool pop() {
    return rootNavigatorNode.pop();
  }

  void popInternalState() {
    if (root?.pop() case final popped?) {
      root = popped;
    } else {
      SystemNavigator.pop();
    }

    notifyListeners();
  }

  List<Page> createPages(BuildContext context) {
    return root!.createPages(context);
  }
}
