import 'package:flutter/material.dart';
import 'package:star/srs/base/exceptions.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/url/route_information_parser.dart';
import 'package:star/srs/url/url_parser.dart';
import 'package:star/srs/utils/consecutive_pages.dart';
import 'package:star/srs/value/route_value.dart';

class ValueRoute<T extends RouteValue> extends StarRoute<T> {
  ValueRoute({
    required this.screenBuilder,
    this.defaultValue,
    this.pageBuilder,
    this.urlParser,
    super.children,
  });

  final Page Function(BuildContext context, Widget child)? pageBuilder;
  final Widget Function(BuildContext context, T value) screenBuilder;
  final T? defaultValue;
  final UrlParser<T>? urlParser;

  @override
  Object get key => T;

  @override
  RouteNode createNode({RouteNode? next, T? value}) {
    value ??= defaultValue;

    if (value == null) {
      throw StarError("No value provided for ValueRoute<$key>");
    }

    return ValueNode(
      buildPage: (context) => buildPage(context, value!),
      next: next,
      value: value,
      urlParser: urlParser,
      route: this,
    );
  }

  Page buildPage(BuildContext context, T value) {
    final screen = screenBuilder(context, value);

    if (pageBuilder != null) {
      return pageBuilder!.call(context, screen);
    }

    return MaterialPage(child: screen);
  }

  @override
  RouteNode<RouteValue>? decodeUrl(
    List<UrlSegmentData> segments,
  ) {
    final data = segments.first;

    if (urlParser case final parser?) {
      if (parser.decode(data) case final value?) {
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
          value: value,
        );
      } else {
        return null;
      }
    } else {
      throw StarError(
          "Couldn't parse url segment: \"${segments.first}\". Please, provide urlParser for $runtimeType");
    }
  }
}

class ValueNode<T extends RouteValue> extends RouteNode {
  ValueNode({
    required this.next,
    required this.value,
    required this.buildPage,
    required super.route,
    this.urlParser,
  });

  final Page Function(BuildContext context) buildPage;
  final UrlParser<T>? urlParser;

  @override
  final RouteNode<RouteValue>? next;

  @override
  final T value;

  @override
  Iterable<Page> createPages(BuildContext context) {
    final page = buildPage(context);
    return consecutive(page, next?.createPages(context));
  }
  
  @override
  Iterable<UrlSegmentData> encodeUrl() {
    if (urlParser case final parser?) {
      final data = parser.encode(value);
      return [data].followedBy(next?.encodeUrl() ?? []);
    } else {
      throw StarError(
          "Couldn't create url segment for $T. Please, provide a urlParser");
    }
  }
}
