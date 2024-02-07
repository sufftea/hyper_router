import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:star/srs/base/exceptions.dart';
import 'package:star/srs/base/star.dart';
import 'package:star/srs/route/star_route.dart';
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
    var segments = routeInformation.uri.pathSegments;
    if (segments.last.isEmpty) {
      segments = segments.sublist(0, segments.length - 1);
      // segments.removeLast();
    }

    final queryParameters = routeInformation.uri.queryParametersAll;
    var state = routeInformation.state as List<Object?>?;

    assert(state == null || state.length == segments.length);

    if (state == null || state.length != segments.length) {
      state = List.filled(segments.length, null);
    }

    try {
      final result = StarRoute.matchUrl(
        segments: List.generate(
          segments.length,
          (i) => UrlSegmentData(
            segment: segments[i],
            queryParameters: queryParameters,
            state: state![i],
          ),
        ),
        routes: roots,
      );

      if (result == null) {
        throw StarException("Couldn't match url: ${routeInformation.uri}");
      }

      return SynchronousFuture(result);
    } on StarException catch (_) {
      return SynchronousFuture(
        config.rootController.createStack(config.errorRoute),
      );
    }
  }

  @override
  RouteInformation? restoreRouteInformation(
    RouteNode<RouteValue> configuration,
  ) {
    final segmentData = configuration.encodeUrl();

    final segments = segmentData.map((e) => e.segment);

    final queryParameters = segmentData.fold(
      <String, List<String>>{},
      (previousValue, e) {
        e.queryParameters.forEach((key, value) {
          if (previousValue.containsKey(key)) {
            previousValue[key]!.addAll(value);
          } else {
            previousValue[key] = value;
          }
        });

        return previousValue;
      },
    );

    final state = segmentData.map((e) => e.state).toList();

    return RouteInformation(
      uri: Uri(
        pathSegments: [''].followedBy(segments),
        queryParameters: queryParameters,
      ),
      state: state,
    );
  }
}

class UrlSegmentData {
  UrlSegmentData({
    required this.segment,
    this.queryParameters = const {},
    this.state,
  });

  final String segment;
  final Map<String, List<String>> queryParameters;
  final Object? state;
}
