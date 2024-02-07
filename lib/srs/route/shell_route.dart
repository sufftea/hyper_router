import 'package:flutter/material.dart';
import 'package:star/srs/base/exceptions.dart';
import 'package:star/srs/route/shell_covering_route.dart';
import 'package:star/srs/url/route_information_parser.dart';
import 'package:star/srs/utils/consecutive_pages.dart';
import 'package:star/srs/value/route_key.dart';
import 'package:star/star.dart';
import 'package:star/srs/base/nested_navigator.dart';

typedef ShellBuilder = Widget Function(
  BuildContext context,
  ShellController controller,
  Widget child,
);

class ShellRoute extends StarRoute<ShellValue> {
  ShellRoute({
    required this.shellBuilder,
    required this.tabs,

    /// Usually, you don't need to provide this. Use this for
    /// [ShellCoveringRoute]
    RouteKey? key,
  })  : key = key ?? RouteKey(),
        super(children: tabs);

  final Widget Function(
    BuildContext context,
    ShellController controller,
    Widget child,
  ) shellBuilder;

  final List<StarRoute> tabs;

  @override
  final RouteKey key;

  @override
  RouteNode createNode({RouteNode? next, ShellValue? value}) {
    if (next != null) {
      if (value != null) {
        value = value.withNext(next);
      } else {
        value = ShellValue.fromNext(
          key: key,
          tabRoutes: tabs,
          next: next,
        );
      }
    } else {
      value = ShellValue.def(key: key, tabs: tabs);
    }

    return ShellNode(
      shellBuilder: shellBuilder,
      value: value,
      route: this,
    );
  }

  @override
  RouteNode<RouteValue> updateNode({
    RouteNode<RouteValue>? next,
    required ShellValue value,
  }) {
    return ShellNode(
      shellBuilder: shellBuilder,
      value: value,
      route: this,
    );
  }

  @override
  RouteNode<RouteValue> copyNode({
    RouteNode<RouteValue>? next,
    required ShellValue value,
  }) {
    return ShellNode(
      shellBuilder: shellBuilder,
      value: value.withNext(next!),
      route: this,
    );
  }

  @override
  RouteNode<RouteValue>? decodeUrl(
    List<UrlSegmentData> segments,
  ) {
    final next = StarRoute.matchUrl(
      segments: segments,
      routes: children,
    );

    if (next == null) {
      return null;
    }

    return createNode(
      next: next,
    );
  }
}

class ShellNode extends RouteNode<ShellValue> {
  ShellNode({
    required this.shellBuilder,
    required this.value,
    required super.route,
  });

  final ShellBuilder shellBuilder;

  @override
  RouteNode<RouteValue> get next => value.currTab;

  @override
  final ShellValue value;
  @override
  RouteKey get key => value.key;

  @override
  Iterable<Page> createPages(BuildContext context) {
    final controller = Star.rootOf(context);
    final shellController = ShellController(
      value: value,
      controller: controller,
    );

    ShellCoveringNode? coveringNode;
    next.forEach((node) {
      if (node is ShellCoveringNode && node.shellKey == key) {
        coveringNode = node;
      }
    });

    late final RouteNode nestedNodes;
    if (coveringNode case final coveringNode?) {
      if (next.cut(coveringNode) case final next?) {
        nestedNodes = next;
      } else {
        nestedNodes = value.tabNodes[value.nonCoveringTabIndex];
      }
    } else {
      nestedNodes = next;
    }

    final page = MaterialPage(
      child: shellBuilder(
        context,
        shellController,
        Builder(builder: (context) {
          return NestedNavigator(
            pages: nestedNodes.createPages(context).toList(),
            key: ValueKey(shellController.tabIndex),
          );
        }),
      ),
    );

    return consecutive(page, coveringNode?.createPages(context));
  }

  @override
  RouteNode<RouteValue>? pop() {
    if (_isShellCovering(next, key)) {
      final updated = route.updateNode(
        next: value.tabNodes[value.nonCoveringTabIndex],
        value: value.withIndex(value.nonCoveringTabIndex),
      );

      return updated;
    }

    if (value.currTab.pop() case final popped?) {
      return route.updateNode(
        next: popped,
        value: value.withNext(popped),
      );
    }

    return null;
  }

  @override
  Iterable<UrlSegmentData> encodeUrl() {
    return next.encodeUrl();
  }
}

class ShellValue extends RouteValue {
  ShellValue({
    required this.tabIndex,
    required this.key,
    required this.tabNodes,
    required this.nonCoveringTabIndex,
  });

  factory ShellValue.def({
    required RouteKey key,
    required List<StarRoute> tabs,
  }) {
    return ShellValue(
      tabIndex: 0,
      key: key,
      tabNodes: tabs.map((e) => e.createNode()!).toList(),
      nonCoveringTabIndex: 0,
    );
  }

  factory ShellValue.fromNext({
    required RouteKey key,
    required List<StarRoute> tabRoutes,
    required RouteNode next,
  }) {
    final tabIndex = tabRoutes.indexWhere((e) => e.key == next.key);

    return ShellValue(
      tabIndex: tabIndex,
      key: key,
      tabNodes: tabRoutes.map((e) {
        if (e.key == next.key) {
          return next;
        }
        return e.createNode()!;
      }).toList(),
      nonCoveringTabIndex: _isShellCovering(next, key) ? 0 : tabIndex,
    );
  }

  final List<RouteNode> tabNodes;
  final int tabIndex;
  final int nonCoveringTabIndex;

  RouteNode get currTab => tabNodes[tabIndex];

  @override
  final RouteKey key;

  ShellValue withIndex(int index) {
    var tab = tabNodes[index];
    if (tab is ShellCoveringNode && tab.shellKey == key && tab.next.isTop) {
      tabNodes[index] = tab.copyStack();
    }

    return ShellValue(
      tabIndex: index,
      key: key,
      tabNodes: tabNodes,
      nonCoveringTabIndex:
          _isShellCovering(tab, key) ? nonCoveringTabIndex : index,
    );
  }

  ShellValue withNext(RouteNode next) {
    final tabIndex =
        tabNodes.indexWhere((tab) => tab.value.key == next.value.key);

    return ShellValue(
      key: key,
      tabIndex: tabIndex,
      tabNodes: tabNodes
          .map((e) => e.value.key == next.value.key ? next : e)
          .toList(),
      nonCoveringTabIndex: _isShellCovering(tabNodes[tabIndex], key)
          ? nonCoveringTabIndex
          : tabIndex,
    );
  }

  bool containsTab(Object key) {
    return tabNodes.any((tab) => tab.value.key == key);
  }

  @override
  String toString() {
    final stacks = [
      for (final tab in tabNodes)
        () {
          final stack = [];
          tab.forEach((node) {
            stack.add(node.value.toString());
          });
          return stack;
        }(),
    ];
    return 'ShellValue(tabIndex: $tabIndex, tabStacks: $stacks)';
  }
}

class ShellController {
  ShellController({
    required this.value,
    required this.controller,
  });

  final ShellValue value;
  int get tabIndex => value.tabIndex;

  RouteNode get root => value.tabNodes[value.tabIndex];

  final RootStarController controller;

  /// [preserveState] behaviour:
  ///   `true`: subroutes within each tab are preserved
  ///   `false`: resets each tab to the first route.
  ///   `null` (default): preserves state when switching tabs; resets to the first
  ///     route when activating the same tab again.
  void setTabIndex(int index, {bool? preserveState}) {
    final ShellValue updatedValue;

    if (preserveState == null && index != value.tabIndex ||
        preserveState == true) {
      updatedValue = value.withIndex(index);
    } else {
      final next = value.tabNodes[index];
      updatedValue = value.withNext(
        next.route.copyNode(
          next: null,
          value: next.value,
        ),
      );
    }

    controller.setStack(
      controller.stack.withUpdatedValue(
        value.key,
        updatedValue,
      ),
    );
  }
}

bool _isShellCovering(RouteNode node, RouteKey key) {
  return node is ShellCoveringNode && node.shellKey == key;
}
