import 'package:flutter/material.dart';
import 'package:tree_router/srs/base/tree_router_controller.dart';

import 'package:tree_router/tree_router.dart';

class ShellRoute extends TreeRoute<ShellValue> {
  ShellRoute({
    required this.shellBuilder,
    required List<TreeRoute> tabs,
    this.onTop = const [],
  })  : controller = ShellController(
          shellValue: ShellValue(
            key: UniqueKey(),
            tabIndex: 0,
            tabs: tabs.map((e) => e.createBuilder()).toList(),
          ),
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
  Object get key => controller.value.key;

  @override
  PageBuilder createBuilder({PageBuilder? next, ShellValue? value}) {
    if (onTop.where((route) => route.key == next?.value.key).isNotEmpty) {
      value = value ?? controller.value;

      return PageBuilder(
        next: next,
        value: value,
        buildPage: (context) => _buildPage(
          context,
          value!,
        ),
      );
    } else {
      if (value == null && next != null) {
        // Navigating to a specific page, changing the selected tab implicitly 
        // (as opposed to calling `setTabIndex` on the controller)
        value = controller.value.withSelected(next);
      }

      if (value == null) {
        throw 'todo';
      }

      return PageBuilder(
        next: null,
        value: value,
        buildPage: (context) => _buildPage(context, value!),
      );
    }
  }

  Page _buildPage(BuildContext context, ShellValue value) {
    final rootController = TreeRouter.of(context);
    controller._activate(value, rootController);

    final parentController = TreeRouter.controllerOf(context);
    parentController.deferTo(controller);

    return MaterialPage(
      child: shellBuilder(
        context,
        controller,
        InheritedRouterController(
          controller: controller,
          child: Builder(
            builder: (context) {
              return NestedRouter(
                pages: controller.createPages(context),
                key: ValueKey(controller.tabIndex),
              );
            }
          ),
        ),
      ),
    );
  }
}

class ShellValue extends RouteValue {
  ShellValue({
    required this.tabIndex,
    required this.key,
    this.tabs = const [],
  });

  final List<PageBuilder> tabs;
  final int tabIndex;

  PageBuilder get currTab => tabs[tabIndex];

  @override
  final Object key;

  ShellValue withSelected(PageBuilder next) {
    return copyWith(
      tabIndex: tabs.indexWhere((tab) => tab.value.key == next.value.key),
      tabs: tabs.map((e) => e.value.key == next.value.key ? next : e).toList(),
    );
  }

  ShellValue copyWith({
    List<PageBuilder>? tabs,
    int? tabIndex,
    Object? key,
  }) {
    return ShellValue(
      tabs: tabs ?? this.tabs,
      tabIndex: tabIndex ?? this.tabIndex,
      key: key ?? this.key,
    );
  }
}

class ShellController with TreeRouterControllerMixin {
  ShellController({
    required ShellValue shellValue,
  }) : _value = shellValue;

  int get tabIndex => value.tabIndex;

  ShellValue get value => _value;
  ShellValue _value;

  RootTreeRouterController? _rootController;

  @override
  PageBuilder? get root => value.tabs[value.tabIndex];

  @override
  TreeRouterControllerMixin? get parent => _parent!;
  TreeRouterControllerMixin? _parent;

  /// [preserveState] behaviour:
  ///   `true`: subroutes within each tab are preserved
  ///   `false`: resets each tab to the first route.
  ///   `null` (default): preserves state when switching tabs; resets to the first
  ///     route when activating the same tab again.
  void setTabIndex(int index, {bool? preserveState}) {
    final oldIndex = value.tabIndex;

    var newValue = value.copyWith(
      tabIndex: index,
    );

    if (!(preserveState ?? index != oldIndex)) {
      newValue = newValue.withSelected(newValue.tabs[index].asTop());
    }

    _rootController!.navigate(newValue);
  }

  void _activate(ShellValue value, RootTreeRouterController controller) {
    _rootController = controller;
    _value = value;
  }
}
