import 'package:flutter/material.dart';
import 'package:star/srs/url/route_information_parser.dart';

import 'package:star/star.dart';
import 'package:star/srs/base/star_controller.dart';
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
    this.onTop = const [],
  }) : super(children: tabs + onTop);

  final Widget Function(
    BuildContext context,
    ShellController controller,
    Widget child,
  ) shellBuilder;

  final List<StarRoute> tabs;
  final List<StarRoute> onTop;

  @override
  final Object key = UniqueKey();

  @override
  RouteNode createNode({RouteNode? next, ShellValue? value}) {
    return ShellNode.createFrom(
      shellBuilder: shellBuilder,
      next: next,
      oldValue: value,
      tabs: tabs.map((e) => e.createNode()).toList(),
      key: key,
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
    required this.onTop,
  });

  factory ShellNode.createFrom({
    required ShellBuilder shellBuilder,
    required RouteNode? next,
    required ShellValue? oldValue,
    required List<RouteNode> tabs,
    required Object key,
  }) {
    final ShellValue value;
    final RouteNode? onTop;

    switch ((oldValue, next)) {
      case (final v?, final n?):
        final withSelected = v.withSelected(n);

        if (withSelected == null) {
          onTop = next;
          value = v;
        } else {
          value = withSelected;
          onTop = null;
        }
      case (null, final n?):
        final index = tabs.indexWhere((e) => e.key == n.key);

        if (index == -1) {
          value = ShellValue(
            tabIndex: 0,
            key: key,
            tabs: tabs,
          );
          onTop = n;
        } else {
          tabs[index] = n;
          value = ShellValue(
            tabIndex: index,
            key: key,
            tabs: tabs,
          );
          onTop = null;
        }
      case (final v?, null):
        value = v;
        onTop = null;
      case (null, null):
        value = ShellValue(
          tabIndex: 0,
          key: key,
          tabs: tabs,
        );
        onTop = null;
      default:
        throw UnimplementedError();
    }

    return ShellNode(
      shellBuilder: shellBuilder,
      onTop: onTop,
      value: value,
    );
  }

  final ShellBuilder shellBuilder;

  @override
  RouteNode<RouteValue> get next => onTop ?? value.currTab;
  final RouteNode? onTop;

  @override
  final ShellValue value;

  @override
  List<Page> createPages(BuildContext context) {
    final controller = Star.of(context);
    final shellController = ShellController(
      value: value,
      controller: controller,
    );

    final page = MaterialPage(
      child: shellBuilder(
        context,
        shellController,
        Builder(builder: (context) {
          return NestedNavigator(
            pages: value.currTab.createPages(context),
            key: ValueKey(shellController.tabIndex),
          );
        }),
      ),
    );

    return [
      page,
      if (onTop != null) ...onTop!.createPages(context),
    ];
  }

  @override
  RouteNode<RouteValue>? pop() {
    if (onTop case final onTop?) {
      final popped = onTop.pop();

      return ShellNode.createFrom(
        shellBuilder: shellBuilder,
        next: popped,
        oldValue: value,
        tabs: value.tabs,
        key: key,
      );
    }

    final popped = value.currTab.pop();

    if (popped == null) {
      return null;
    }

    return ShellNode.createFrom(
      shellBuilder: shellBuilder,
      next: popped,
      oldValue: value,
      tabs: value.tabs,
      key: key,
    );
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
    required this.tabs,
  });

  final List<RouteNode> tabs;
  final int tabIndex;

  RouteNode get currTab => tabs[tabIndex];

  @override
  final Object key;

  ShellValue? withSelected(RouteNode next) {
    final index = tabs.indexWhere((tab) => tab.value.key == next.value.key);

    if (index == -1) {
      return null;
    }

    return copyWith(
      tabIndex: index,
      tabs: tabs.map((e) => e.value.key == next.value.key ? next : e).toList(),
    );
  }

  bool containsTab(Object key) {
    return tabs.any((tab) => tab.value.key == key);
  }

  ShellValue copyWith({
    List<RouteNode>? tabs,
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

class ShellController {
  ShellController({
    required this.value,
    required this.controller,
  });

  final ShellValue value;
  int get tabIndex => value.tabIndex;

  RouteNode get root => value.tabs[value.tabIndex];

  final StarController controller;

  /// [preserveState] behaviour:
  ///   `true`: subroutes within each tab are preserved
  ///   `false`: resets each tab to the first route.
  ///   `null` (default): preserves state when switching tabs; resets to the first
  ///     route when activating the same tab again.
  void setTabIndex(int index, {bool? preserveState}) {
    final oldIndex = value.tabIndex;

    final target = switch (preserveState ?? index != oldIndex) {
      true => value.tabs[index].last().value,
      false => value.tabs[index].value,
    };

    final values = <RouteValue>{};
    value.tabs[index].forEach((builder) {
      values.add(builder.value);
    });

    controller.navigate(target, values);
  }
}
