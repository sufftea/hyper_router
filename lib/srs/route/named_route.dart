import 'package:flutter/material.dart';
import 'package:hyper_router/srs/url/url_data.dart';
import 'package:hyper_router/srs/utils/hyper_iterable_x.dart';
import 'package:hyper_router/hyper_router.dart';

class NamedRoute extends ValueRoute<RouteName> {
  NamedRoute({
    required Widget Function(BuildContext context) screenBuilder,
    required this.name,
    super.pageBuilder,
    super.children,
  }) : super(
          screenBuilder: (context, value) => screenBuilder(context),
          defaultValue: name,
        );

  final RouteName name;

  @override
  Object get key => name.key;

  @override
  RouteNode<RouteValue> createNode({
    RouteNode<RouteValue>? next,
    RouteName? value,
  }) {
    return NamedNode(
      next: next,
      value: name,
      buildPage: (context) => buildPage(context, name),
      route: this,
    );
  }

  @override
  RouteNode<RouteValue>? createFromUrl(
    UrlData url,
  ) {
    if (url.segments.first == name.name) {
      return createNode(
        next: nextNodeFromUrl(url.copyWith(url.segments.skip(1))),
        value: name,
      );
    }

    return null;
  }
}

class NamedNode extends RouteNode<RouteName> {
  NamedNode({
    required this.next,
    required this.value,
    required this.buildPage,
    required super.route,
  });

  final Page Function(BuildContext context) buildPage;

  @override
  final RouteNode<RouteValue>? next;

  @override
  final RouteName value;

  @override
  Iterable<Page> createPages(BuildContext context) {
    final page = buildPage(context);

    return [page].followedByOptional(next?.createPages(context));
  }

  @override
  UrlData toUrl() {
    final result = UrlData(segments: [value.name]);
    
    if (next case final next?) {
      return result.followedBy(next.toUrl());
    }

    return result;
  }
}
