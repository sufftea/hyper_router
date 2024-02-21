import 'package:hyper_router/srs/url/url_data.dart';

class HyperError extends Error {
  HyperError(this.message);
  final String message;

  @override
  String toString() {
    return "HyperError: $message";
  }
}

class HyperException implements Exception {
  HyperException(this.message);
  final String message;

  @override
  String toString() {
    return 'HyperException: $message';
  }
}

class UrlParsingException implements Exception {
  UrlParsingException({
    required this.url,
  });

  final UrlData url;
}
