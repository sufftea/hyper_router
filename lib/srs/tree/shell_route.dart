import 'package:flutter/material.dart';

import 'package:flutter_stack_router/srs/base/my_router_delegate.dart';
import 'package:flutter_stack_router/srs/base/nested_my_router.dart';
import 'package:flutter_stack_router/srs/tree/my_route.dart';
import 'package:flutter_stack_router/srs/tree/route_value.dart';

class ShellRoute extends MyRoute<ShellValue> {
  ShellRoute({
    required this.shellBuilder,
    required List<MyRoute> tabs,
    this.onTop = const [],
  })  : controller = ShellController(
          routes: tabs,
          shellValue: ShellValue(key: UniqueKey(), tabIndex: 0),
        ),
        super(children: tabs + onTop);

  final Widget Function(
    BuildContext context,
    ShellController controller,
    Widget child,
  ) shellBuilder;

  final ShellController controller;
  List<MyRoute> onTop;

  @override
  ShellValue get value => controller.shellValue;
  @override
  set value(ShellValue value) {
    controller._shellValue = value;
  }

  @override
  MyRoute? get next => _next;
  MyRoute? _next;
  @override
  set next(MyRoute? next) {
    final index =
        controller.routes.indexWhere((route) => route.key == next?.key);

    if (index != -1) {
      controller.setTabIndex(index);
    } else if (onTop.where((route) => route.key == next?.key).isNotEmpty) {
      _next = next;
    } else {
      throw 'todo';
    }
  }

  @override
  Object get key => controller.shellValue.key;

  @override
  Widget buildScreen(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final navigator = NestedMyRouter(
          notifier: controller,
          roots: controller.routes,
          key: ValueKey(controller.tabIndex),
        );

        return shellBuilder(
          context,
          controller,
          navigator,
        );
      },
    );
  }
}

class ShellValue extends RouteValue {
  ShellValue({
    required this.tabIndex,
    required this.key,
    this.tabValues = const [],
  });

  final List<RouteValue> tabValues;
  final int tabIndex;

  RouteValue get tabValue => tabValues[tabIndex];

  @override
  final Object key;

  ShellValue copyWith({
    List<RouteValue>? tabValues,
    int? tabIndex,
    Object? key,
  }) {
    return ShellValue(
      tabValues: tabValues ?? this.tabValues,
      tabIndex: tabIndex ?? this.tabIndex,
      key: key ?? this.key,
    );
  }
}

class ShellController extends RouterDelegateNotifier {
  ShellController({
    required this.routes,
    required ShellValue shellValue,
  }) : _shellValue = shellValue;

  final List<MyRoute> routes;
  MyRoute get currRoute => routes[shellValue.tabIndex];

  ShellValue _shellValue;
  ShellValue get shellValue => _shellValue;

  /// [preserveState] behaviour:
  ///   `null` (default): preserves state when switching tabs,
  /// TODO
  void setTabIndex(int index, {bool? preserveState}) {
    _shellValue = shellValue.copyWith(
      tabIndex: index,
    );
    // if (!preserveState) {
    //   tabRoute.next = null;
    // }
    notifyListeners();
  }

  int get tabIndex => _shellValue.tabIndex;

  void setTabValue(RouteValue value) {
    final index = routes.indexWhere((route) => route.key == value.key);

    if (index == -1) {
      throw 'todo';
    }

    setTabIndex(index);
  }

  @override
  MyRoute<RouteValue> get stackRoot => routes[_shellValue.tabIndex];
}
