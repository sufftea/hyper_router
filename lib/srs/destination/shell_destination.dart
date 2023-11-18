import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/destination/destination.dart';
import 'package:flutter_stack_router/srs/nested_stack_router.dart';
import 'package:flutter_stack_router/srs/route_stack.dart';
import 'package:flutter_stack_router/srs/stack_router.dart';
import 'package:flutter_stack_router/srs/stack_router_controller.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';

class ShellDestination extends Destination<ShellRouterValue> {
  ShellDestination({
    required this.tabs,
    required this.shellBuilder,
    this.overlayedChildren = const [],
    this.preserveTabStacks = true,
  })  : _configKey = UniqueKey(),
        _tabNavigatorKeys = [for (final _ in tabs) UniqueKey()],
        super(children: [...tabs, ...overlayedChildren]);

  final List<Destination> tabs;
  final List<Destination> overlayedChildren;
  final Object _configKey;
  final bool preserveTabStacks;
  final List<Key> _tabNavigatorKeys;

  Widget Function(
    BuildContext context,
    ShellRouterController controller,
    Widget child,
  ) shellBuilder;

  @override
  Widget buildScreen(BuildContext context, ShellRouterValue value) {
    final navigator = NestedStackRouter(
      stack: value.currStack.list,
      destinations: tabs,
      key: _tabNavigatorKeys[value.selectedTab],
    );

    return shellBuilder(
      context,
      ShellRouterController(
        rootController: StackRouter.of(context),
        value: value,
      ),
      navigator,
    );
  }

  @override
  Object get key => _configKey;

  @override
  List<DestinationValue> visit({
    required ShellRouterValue? currentValue,
    required Iterable<DestinationValue> onTop,
  }) {
    final tabIndex = tabs.indexed
        .where((t) => t.$2.acceptsValue(onTop.first))
        .firstOrNull
        ?.$1;

    final config = ShellRouterValue(
      tabs: currentValue?.tabs ?? List.filled(tabs.length, RouteStack([])),
      selectedTab: tabIndex ?? 0,
      key: _configKey,
    );

    if (tabIndex == null) {
      if (overlayedChildren
          .where((destination) => destination.acceptsValue(onTop.first))
          .isNotEmpty) {
        return [
          config,
          ...onTop,
        ];
      } else {
        throw 'todo';
      }
    }

    config.tabs[tabIndex] = RouteStack(onTop.toList());

    return [config];
  }

  @override
  ShellRouterValue? onPop(ShellRouterValue currValue) {
    final res = currValue.popped();

    return res.currStack.list.isEmpty ? null : res;
  }
}

// TODO: maybe I should mandate each tab having at least one value?
class ShellRouterValue extends DestinationValue {
  ShellRouterValue({
    required Object key,
    required this.tabs,
    this.selectedTab = 0,
  }) : _key = key;

  final Object _key;
  final int selectedTab;
  final List<RouteStack> tabs;
  RouteStack get currStack => tabs[selectedTab];

  @override
  Object get key {
    return _key;
  }

  ShellRouterValue popped() {
    return ShellRouterValue(
      key: key,
      tabs: tabs.indexed
          .map((e) => e.$1 == selectedTab ? e.$2.popped() : e.$2)
          .toList(),
      selectedTab: selectedTab,
    );
  }
}

class ShellRouterController {
  ShellRouterController({
    required this.rootController,
    required ShellRouterValue value,
  }) : _value = value;

  final StackRouterController rootController;
  final ShellRouterValue _value;

  int get tab => _value.selectedTab;
  set tab(int index) {
    final target = _value.tabs[index].list.lastOrNull;

    if (target == null) {
      throw 'todo';
    }

    rootController.navigate(target);
  }
}
