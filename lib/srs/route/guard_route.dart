import 'package:flutter/material.dart';
import 'package:fractal_router/srs/route/froute.dart';
import 'package:fractal_router/srs/value/route_value.dart';

class GuardValue extends RouteValue {
  GuardValue(this.key);

  @override
  final Object key;
}

class GuardRoute extends Froute {
  GuardRoute({
    super.children,
  });

  @override
  Object get key => UniqueKey();

  @override
  PageBuilder<RouteValue> createBuilder({
    PageBuilder<RouteValue>? next,
    RouteValue? value,
  }) {
    return GuardPageBuilder(
      next: next!,
      key: key,
    );
  }
}

class GuardPageBuilder extends PageBuilder<RouteValue> {
  GuardPageBuilder({
    required this.next,
    required Object key,
  }) : value = GuardValue(key);
  
  @override
  final RouteValue value;

  @override
  PageBuilder<RouteValue>? next;

  @override
  List<Page> createPages(BuildContext context) {
    return next!.createPages(context);
  }

  @override
  PageBuilder<RouteValue>? pop() {
    if (next!.pop() case final next?) {
      return GuardPageBuilder(next: next, key: key);
    } else {
      return null;
    }
  }
}
