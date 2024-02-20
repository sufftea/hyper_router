import 'package:flutter/material.dart';
import 'package:star/srs/base/exceptions.dart';
import 'package:star/srs/base/nested_navigator.dart';
import 'package:star/srs/route/shell_covering_route.dart';
import 'package:star/srs/route/shell_route/shell_controller.dart';
import 'package:star/srs/route/shell_route/shell_value.dart';
import 'package:star/srs/url/url_data.dart';
import 'package:star/srs/utils/consecutive_pages.dart';
import 'package:star/srs/value/route_key.dart';
import 'package:star/star.dart';

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

    return followByIterable(page, coveringNode?.createPages(context));
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
  UrlData toUrl() {
    return next.toUrl();
  }
}

bool _isShellCovering(RouteNode node, RouteKey key) {
  return node is ShellCoveringNode && node.shellKey == key;
}
