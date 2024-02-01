import 'package:star/srs/url/route_information_parser.dart';

abstract class UrlParser<T> {
  UrlParser();

  UrlSegmentData encode(T value);

  T? decode(UrlSegmentData data);
}

class QueryParamsUrlParser<T> extends UrlParser<T> {
  QueryParamsUrlParser({
    required this.encodeSegment,
    required this.decodeSegment,
  });

  final (String segment, Map<String, String?> queryParameters) Function(T value)
      encodeSegment;

  /// Return `null` if the provided data doesn't match the route
  final T? Function(String segment, Map<String, String?> queryParams)
      decodeSegment;

  @override
  UrlSegmentData encode(value) {
    final (segment, queryParameters) = encodeSegment(value);

    return UrlSegmentData(
      segment: segment,
      queryParameters: queryParameters.map(
        (key, value) => MapEntry(key, value == null ? [] : [value]),
      ),
    );
  }

  @override
  T? decode(UrlSegmentData data) {
    return decodeSegment(
      data.segment,
      data.queryParameters.map(
        (key, value) => MapEntry(key, value.firstOrNull),
      ),
    );
  }
}
