import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractal_router/srs/tree/froute.dart';
import 'package:fractal_router/srs/tree/route_value.dart';

class FractalController extends ChangeNotifier {
  FractalController({
    required List<Froute> roots,
    required RouteValue initialRoute,
  }) {
    for (final r in roots) {
      r.forEach((r) {
        _routeMap[r.key] = r;
      });
    }

    navigate(initialRoute);
  }

  PageBuilder? root;

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

  void pop() {
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

class InheritedFractalController extends InheritedWidget {
  const InheritedFractalController({
    required this.controller,
    required super.child,
    super.key,
  });

  final FractalController controller;

  @override
  bool updateShouldNotify(InheritedFractalController oldWidget) {
    return oldWidget.controller != controller;
  }
}
