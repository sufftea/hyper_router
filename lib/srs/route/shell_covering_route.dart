import 'package:flutter/material.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/url/route_information_parser.dart';
import 'package:star/srs/value/route_key.dart';
import 'package:star/srs/value/route_value.dart';

class ShellCoveringRoute extends StarRoute {
  ShellCoveringRoute({
    required this.shellKey,
    required super.children,
  }) : assert(children.isNotEmpty,
            "[ShellCoveringRoute] serves as a proxy for its children and can't be displayed on its own. Provide at least one child");

  /// The key of the [ShellRoute] that this route and its children should cover.
  final RouteKey shellKey;

  @override
  RouteNode<RouteValue>? createNode({
    RouteNode<RouteValue>? next,
    RouteValue? value,
  }) {
    return ShellCoveringNode(
      shellKey: shellKey,
      next: next ?? children.first.createNode()!,
      value: ShellCoveringRouteValue(key),
      route: this,
    );
  }

  @override
  RouteNode<RouteValue>? decodeUrl(List<UrlSegmentData> segments) {
    return StarRoute.matchUrl(
      segments: segments,
      routes: children,
    );
  }

  @override
  final RouteKey key = RouteKey();
}

class ShellCoveringNode extends RouteNode<ShellCoveringRouteValue> {
  ShellCoveringNode({
    required this.shellKey,
    required this.value,
    required this.next,
    required super.route,
  });

  final RouteKey shellKey;

  @override
  final ShellCoveringRouteValue value;

  @override
  final RouteNode<RouteValue> next;

  @override
  Iterable<Page> createPages(BuildContext context) {
    return next.createPages(context);
  }

  @override
  RouteNode<RouteValue>? pop() {
    return next.pop();
  }

  @override
  Iterable<UrlSegmentData> encodeUrl() {
    return next.encodeUrl();
  }

  @override
  RouteNode<RouteValue>? cut(Object key) {
    return next.cut(key);
  }
}

class ShellCoveringRouteValue extends RouteValue {
  ShellCoveringRouteValue(this.key);

  @override
  final RouteKey key;
}
