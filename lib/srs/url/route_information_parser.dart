import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hyper_router/srs/base/entities.dart';
import 'package:hyper_router/srs/base/exceptions.dart';
import 'package:hyper_router/srs/base/hyper_router.dart';
import 'package:hyper_router/srs/route/hyper_route.dart';
import 'package:hyper_router/srs/url/url_data.dart';
import 'package:hyper_router/srs/value/route_value.dart';

class HyperRouteInformationParser extends RouteInformationParser<RouteNode> {
  HyperRouteInformationParser({
    required this.config,
  });

  final HyperRouter config;
  List<HyperRoute> get roots => config.routes;

  @override
  Future<RouteNode<RouteValue>> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    try {
      var segments = routeInformation.uri.pathSegments;
      if (segments.last.isEmpty) {
        segments = segments.sublist(0, segments.length - 1);
      }

      final url = UrlData(
        segments: segments,
        queryParams: routeInformation.uri.queryParametersAll,
        states: routeInformation.state as Map<Object, Object?>? ?? {},
      );
      final result = HyperRoute.matchUrl(
        url: url,
        routes: roots,
      );

      if (result == null) {
        throw UrlParsingException(url: url);
      }

      return SynchronousFuture(result);
    } on Exception catch (e) {
      final redirect = config.onException(OnExceptionState(
        exception: e,
        routeInformation: routeInformation,
      ));
      if (redirect case final value?) {
        return SynchronousFuture(config.rootController.createStack(value));
      } else {
        rethrow;
      }
    }
  }

  @override
  RouteInformation? restoreRouteInformation(
    RouteNode<RouteValue> configuration,
  ) {
    final url = configuration.toUrl();

    return RouteInformation(
      uri: Uri(
        pathSegments: [''].followedBy(url.segments),
        queryParameters: url.queryParams,
      ),
      state: url.states,
    );
  }
}
