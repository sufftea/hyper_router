import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:star/srs/base/entities.dart';
import 'package:star/srs/base/exceptions.dart';
import 'package:star/srs/base/star.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/url/url_data.dart';
import 'package:star/srs/value/route_value.dart';

class StarRouteInformationParser extends RouteInformationParser<RouteNode> {
  StarRouteInformationParser({
    required this.config,
  });

  final Star config;
  List<StarRoute> get roots => config.routes;

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
      final result = StarRoute.matchUrl(
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
