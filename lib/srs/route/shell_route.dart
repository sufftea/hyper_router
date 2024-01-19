import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fractal_router/fractal_router.dart';
import 'package:fractal_router/srs/base/controller.dart';
import 'package:fractal_router/srs/base/nested_navigator.dart';

typedef ShellBuilder = Widget Function(
  BuildContext context,
  ShellController controller,
  Widget child,
);

class ShellRoute extends Froute<ShellValue> {
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

  final List<Froute> tabs;
  final List<Froute> onTop;

  @override
  final Object key = UniqueKey();

  @override
  PageBuilder createBuilder({PageBuilder? next, ShellValue? value}) {
    return ShellPageBuilder.createFrom(
      shellBuilder: shellBuilder,
      next: next,
      oldValue: value,
      tabs: tabs.map((e) => e.createBuilder()).toList(),
      key: key,
    );
  }
}

class ShellPageBuilder extends PageBuilder<ShellValue> {
  ShellPageBuilder({
    required this.shellBuilder,
    required this.value,
    required this.onTop,
  });

  factory ShellPageBuilder.createFrom({
    required ShellBuilder shellBuilder,
    required PageBuilder? next,
    required ShellValue? oldValue,
    required List<PageBuilder> tabs,
    required Object key,
  }) {
    final ShellValue value;
    final PageBuilder? onTop;

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

    return ShellPageBuilder(
      shellBuilder: shellBuilder,
      onTop: onTop,
      value: value,
    );
  }

  final ShellBuilder shellBuilder;

  @override
  PageBuilder<RouteValue>? get next => onTop ?? value.currTab;
  final PageBuilder? onTop;

  @override
  final ShellValue value;

  @override
  List<Page> createPages(BuildContext context) {
    final controller = FractalRouter.of(context);
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
  PageBuilder<RouteValue>? pop() {
    if (onTop case final onTop?) {
      final popped = onTop.pop();

      return ShellPageBuilder.createFrom(
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

    return ShellPageBuilder.createFrom(
      shellBuilder: shellBuilder,
      next: popped,
      oldValue: value,
      tabs: value.tabs,
      key: key,
    );
  }
}

class ShellValue extends RouteValue {
  ShellValue({
    required this.tabIndex,
    required this.key,
    required this.tabs,
  });

  final List<PageBuilder> tabs;
  final int tabIndex;

  PageBuilder get currTab => tabs[tabIndex];

  @override
  final Object key;

  ShellValue? withSelected(PageBuilder next) {
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

class ShellController {
  ShellController({
    required this.value,
    required this.controller,
  });

  final ShellValue value;
  int get tabIndex => value.tabIndex;

  PageBuilder get root => value.tabs[value.tabIndex];

  final FractalController controller;

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
