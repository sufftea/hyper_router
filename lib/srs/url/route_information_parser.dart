import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:star/srs/base/exceptions.dart';
import 'package:star/srs/route/star_route.dart';
import 'package:star/srs/value/route_value.dart';

class StarRouteInformationParser extends RouteInformationParser<RouteNode> {
  StarRouteInformationParser({
    required this.roots,
  });

  final List<StarRoute> roots;

  @override
  Future<RouteNode<RouteValue>> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    final segments = routeInformation.uri.pathSegments;
    final queryParameters = routeInformation.uri.queryParametersAll;
    var state = routeInformation.state as List<Object?>?;


    debugPrint('decoding url: $segments');

    assert(state == null || state.length == segments.length);

    if (state == null || state.length != segments.length) {
      state = List.filled(segments.length, null);
    }

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
      throw StarError("Couldn't match url: ${routeInformation.uri}");
    }

    return SynchronousFuture(result);
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

    debugPrint('encoding url: $segments');

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
