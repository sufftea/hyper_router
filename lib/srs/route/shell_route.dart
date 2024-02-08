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
    return ShellNode(
      shellBuilder: shellBuilder,
      value: switch ((next, value)) {
        (final next?, final value?) => value.withNext(next),
        (final next?, null) => ShellValue.fromNext(
            key: key,
            tabRoutes: tabs,
            next: next,
          ),
        (null, final value?) => value,
        (null, null) => value = ShellValue.def(key: key, tabs: tabs),
      },
      route: this,
    );
  }

  @override
  RouteNode<RouteValue> updateWithValue({
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
  RouteNode<RouteValue> updateWithNext({
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

    if (_isShellCovering(next, key)) {
      throw StarError(
          "[ShellCoveringNode] can't be a direct child of [ShellRoute]");
    }

    ShellCoveringNode? coveringNode;
    next.next?.forEach((node) {
      if (node is ShellCoveringNode && node.shellKey == key) {
        coveringNode = node;
      }
    });

    late final RouteNode nextCut;
    if (coveringNode case final coveringNode?) {
      if (next.cut(coveringNode) case final next?) {
        nextCut = next;
      }
    } else {
      nextCut = next;
    }

    final page = MaterialPage(
      child: shellBuilder(
        context,
        shellController,
        Builder(builder: (context) {
          return NestedNavigator(
            pages: nextCut.createPages(context).toList(),
            key: ValueKey(shellController.tabIndex),
          );
        }),
      ),
    );

    return consecutive(page, coveringNode?.createPages(context));
  }

  @override
  RouteNode<RouteValue>? pop() {
    if (value.currTab.pop() case final popped?) {
      return route.updateWithValue(
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
  });

  factory ShellValue.def({
    required RouteKey key,
    required List<StarRoute> tabs,
  }) {
    return ShellValue(
      tabIndex: 0,
      key: key,
      tabNodes: tabs.map((e) => e.createNode()!).toList(),
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
    );
  }

  final List<RouteNode> tabNodes;
  final int tabIndex;

  RouteNode get currTab => tabNodes[tabIndex];

  @override
  final RouteKey key;

  ShellValue withIndex(int index) {
    return ShellValue(
      tabIndex: index,
      key: key,
      tabNodes: tabNodes,
    );
  }

  ShellValue withNext(RouteNode next) {
    return ShellValue(
      key: key,
      tabIndex: tabNodes.indexWhere((tab) => tab.value.key == next.value.key),
      tabNodes: tabNodes
          .map((e) => e.value.key == next.value.key ? next : e)
          .toList(),
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

    if (preserveState == null || preserveState == true) {
      if (index != value.tabIndex) {
        updatedValue = value.withIndex(index);
      } else {
        final next = value.tabNodes[index];
        updatedValue = value.withNext(
          next.route.updateWithNext(
            next: null,
            value: next.value,
          ),
        );
      }
    } else {
      final next = value.tabNodes[index];
      updatedValue = value.withNext(
        next.route.updateWithNext(
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
