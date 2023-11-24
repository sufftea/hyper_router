import 'package:flutter/material.dart';

import 'package:tree_router/srs/base/tree_router_delegate.dart';
import 'package:tree_router/tree_router.dart';

class ShellRoute extends TreeRoute<ShellValue> {
  ShellRoute({
    required this.shellBuilder,
    required List<TreeRoute> tabs,
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
  List<TreeRoute> onTop;

  @override
  ShellValue get value => controller.shellValue;
  @override
  set value(ShellValue value) {
    controller._shellValue = value;
  }

  @override
  TreeRoute? get next => _next;
  TreeRoute? _next;
  @override
  set next(TreeRoute? next) {
    final index =
        controller.routes.indexWhere((route) => route.key == next?.key);

    if (index != -1) {
      controller.setTabIndex(index, preserveState: true);
    } else if (onTop.where((route) => route.key == next?.key).isNotEmpty) {
      _next = next;
    } else if (next == null) {
      _next = null;
    } else {
      throw 'todo';
    }
  }

  @override
  Object get key => controller.shellValue.key;

  @override
  List<Page> createPages(BuildContext context) {
    final b = ChildBackButtonDispatcher(
        TreeRouter.configOf(context).backButtonDispatcher);
    if (next == null) {
      b.takePriority();
    }

    return [
      _buildPage(context, b),
      ...next?.createPages(context) ?? [],
    ];
  }

  Widget _buildScreen(
    BuildContext context,
    BackButtonDispatcher backButtonDispatcher,
  ) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final navigator = NestedRouter(
          notifier: controller,
          roots: controller.routes,
          backButtonDispatcher: backButtonDispatcher,
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

  Page _buildPage(
    BuildContext context,
    BackButtonDispatcher backButtonDispatcher,
  ) {
    return MaterialPage(child: _buildScreen(context, backButtonDispatcher));
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

  final List<TreeRoute> routes;
  TreeRoute get currRoute => routes[shellValue.tabIndex];

  ShellValue _shellValue;
  ShellValue get shellValue => _shellValue;

  /// [preserveState] behaviour:
  ///   `true`: subroutes within each tab are preserved
  ///   `false`: resets each tab to the first route.
  ///   `null` (default): preserves state when switching tabs; resets to the first
  ///     route when activating the same tab again.
  void setTabIndex(int index, {bool? preserveState}) {
    final oldIndex = shellValue.tabIndex;

    _shellValue = shellValue.copyWith(
      tabIndex: index,
    );

    if (!(preserveState ?? index != oldIndex)) {
      currRoute.next = null;
    }

    notifyListeners();
  }

  int get tabIndex => _shellValue.tabIndex;

  @override
  TreeRoute<RouteValue> get stackRoot => routes[_shellValue.tabIndex];
}
