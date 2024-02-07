import 'package:flutter/material.dart';
import 'package:star/srs/base/exceptions.dart';
import 'package:star/srs/url/route_information_parser.dart';
import 'package:star/srs/utils/consecutive_pages.dart';
import 'package:star/star.dart';

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
  RouteNode<RouteValue>? decodeUrl(
    List<UrlSegmentData> segments,
  ) {
    final data = segments.first;

    if (data.segment == name.name) {
      final next = StarRoute.matchUrl(
        segments: segments.sublist(1),
        routes: children,
      );

      if (next == null && segments.length >= 2) {
        throw StarException(
            "Couldn't match a url segment: ${segments[1].segment}");
      }

      return createNode(
        next: next,
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

    return consecutive(page, next?.createPages(context));
  }

  @override
  Iterable<UrlSegmentData> encodeUrl() {
    return [UrlSegmentData(segment: value.name)]
        .followedBy(next?.encodeUrl() ?? []);
  }
}
