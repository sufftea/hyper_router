import 'dart:async';

import 'package:flutter/material.dart';
import 'package:star/srs/base/exceptions.dart';
import 'package:star/srs/url/route_information_parser.dart';

import 'package:star/srs/value/route_value.dart';

class UrlParsingException extends StarException {
  UrlParsingException(super.message);
}

abstract class StarRoute<T extends RouteValue> {
  StarRoute({
    this.children = const [],
  }) {
    for (final child in children) {
      child.parent = this;
    }
  }

  final List<StarRoute> children;
  late final StarRoute? parent;

  Object get key;

  RouteNode? createNode({
    RouteNode? next,
    T? value,
  });

  /// Prioritizes [value] over [next].
  /// - [next] is what the node is currently pointing towards.
  /// - [value] is the value the returned node is expected to contain.
  RouteNode updateWithValue({
    RouteNode? next,
    required T value,
  }) {
    return createNode(next: next, value: value)!;
  }

  /// Prioritizes [next] over [value].
  /// - [value] is the current value of the node.
  /// - [next] is what the returned node is expected to be pointing to.
  RouteNode updateWithNext({
    RouteNode? next,
    required T value,
  }) {
    return createNode(next: next, value: value)!;
  }

  /// Receives a list of url segments and returns the stack parsed from them.
  /// The first segment in the list is matched against this route. If it does
  /// not correspond to this route, returns null.
  ///
  /// A segment is a part of the url separated by slashes ('/'). The slashes are
  /// not included into the segment.
  RouteNode? decodeUrl(List<UrlSegmentData> segments);

  static RouteNode? matchUrl({
    required List<UrlSegmentData> segments,
    required List<StarRoute> routes,
  }) {
    if (segments.isEmpty) {
      return null;
    }

    for (final route in routes) {
      final node = route.decodeUrl(segments);
      if (node != null) {
        return node;
      }
    }

    return null;
  }
}

abstract class RouteNode<T extends RouteValue> {
  RouteNode({required this.route});

  RouteNode? get next;
  T get value;
  final StarRoute route;
  Object get key => value.key;
  final popCompleter = Completer();

  bool get isTop => next == null;

  Iterable<Page> createPages(BuildContext context);

  RouteNode? pop() {
    if (next case final next?) {
      return route.updateWithNext(next: next.pop(), value: value);
    }
    return null;
  }

  /// Converts the stack into a list of url segments.
  Iterable<UrlSegmentData> encodeUrl();

  RouteNode? cut(Object key) {
    if (key == this.key) {
      return null;
    }
    return route.updateWithNext(next: next?.cut(key), value: value);
  }

  RouteNode last() {
    RouteNode curr = this;

    while (curr.next != null) {
      curr = curr.next!;
    }

    return curr;
  }

  /// Returns a copy of the stack where the node with [key] is replaced with a
  /// node containing the provided value.
  RouteNode withUpdatedValue(Object key, RouteValue value) {
    if (key == this.key) {
      return route.updateWithValue(next: next, value: value);
    }
    return route.updateWithNext(
      next: next?.withUpdatedValue(key, value),
      value: this.value,
    );
  }

  RouteNode copyStack() {
    return route.updateWithNext(
      value: value,
      next: next?.copyStack(),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RouteNode && other.hashCode == this.hashCode;
  }

  @override
  int get hashCode => super.hashCode + next.hashCode;
}

extension RouteNodeX on RouteNode {
  void forEach(void Function(RouteNode node) action) {
    RouteNode? curr = this;
    while (curr != null) {
      action(curr);
      curr = curr.next;
    }
  }

  bool containsNode(Object key) {
    if (this.key == key) {
      return true;
    } else if (next case final next?) {
      return next.containsNode(key);
    }

    return false;
  }
}

extension TreeRouteX<T extends RouteValue> on StarRoute<T> {
  void forEach(void Function(StarRoute r) action) {
    action(this);
    for (final child in children) {
      child.forEach(action);
    }
  }

  /// Creates a stack of [RouteNode]s from this route to the root.
  RouteNode? createStack({
    RouteNode? next,
    required Map<Object, RouteValue> values,
  }) {
    final node = createNode(
      next: next,
      value: values[key] as T?,
    );

    if (parent case final parent?) {
      return parent.createStack(
        next: node,
        values: values,
      );
    } else {
      return node;
    }
  }
}
