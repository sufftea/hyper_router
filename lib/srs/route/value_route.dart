import 'package:flutter/material.dart';
import 'package:hyper_router/srs/base/exceptions.dart';
import 'package:hyper_router/srs/route/hyper_route.dart';
import 'package:hyper_router/srs/url/url_data.dart';
import 'package:hyper_router/srs/url/url_parser.dart';
import 'package:hyper_router/srs/utils/hyper_iterable_x.dart';
import 'package:hyper_router/srs/value/route_value.dart';

class ValueRoute<T extends RouteValue> extends HyperRoute<T> {
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
      throw HyperError("No value provided for ValueRoute<$key>");
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
  RouteNode<RouteValue>? createFromUrl(UrlData url) {
    if (urlParser case final parser?) {
      if (parser.decode(url) case (final value, final remaining)?) {
        return createNode(
          next: nextNodeFromUrl(url.copyWith(remaining)),
          value: value,
        );
      } else {
        return null;
      }
    } else {
      return null;
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
    return [page].followedByOptional(next?.createPages(context));
  }

  @override
  UrlData toUrl() {
    if (urlParser case final parser?) {
      final url = parser.encode(value);

      if (next case final next?) {
        return url.followedBy(next.toUrl());
      }

      return url;
    } else {
      throw HyperError(
          "Couldn't create url segment for $T. Please, provide a urlParser");
    }
  }
}
