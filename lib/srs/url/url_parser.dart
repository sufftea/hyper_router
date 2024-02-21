// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hyper_router/srs/url/url_data.dart';

abstract class UrlParser<T> {
  UrlData encode(T value);

  (T value, Iterable<String> remainingSegments)? decode(UrlData url);
}

abstract class UrlSegmentParser<T> extends UrlParser<T> {
  SegmentData encodeSegment(T value);

  T? decodeSegment(SegmentData segment);

  @override
  UrlData encode(T value) {
    final segment = encodeSegment(value);

    return UrlData(
      segments: [segment.name],
      queryParams: segment.queryParams,
      states: segment.state,
    );
  }

  @override
  (T, Iterable<String>)? decode(UrlData url) {
    final value = decodeSegment(SegmentData(
      name: url.segments.first,
      queryParams: url.queryParams,
      state: url.states,
    ));

    if (value == null) {
      return null;
    }

    return (value, url.segments.skip(1));
  }
}

class SegmentData {
  SegmentData({
    required this.name,
    final Map<String, List<String>>? queryParams,
    final Map<Object, Object?>? state,
  })  : queryParams = queryParams ?? {},
        state = state ?? {};

  final String name;
  final Map<String, List<String>> queryParams;
  final Map<Object, Object?> state;
}
