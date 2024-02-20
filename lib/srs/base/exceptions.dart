import 'package:star/srs/url/url_data.dart';

class StarError extends Error {
  StarError(this.message);
  final String message;

  @override
  String toString() {
    return "StarError: $message";
  }
}

class StarException implements Exception {
  StarException(this.message);
  final String message;

  @override
  String toString() {
    return 'StarException: $message';
  }
}

class UrlParsingException implements Exception {
  UrlParsingException({
    required this.url,
  });

  final UrlData url;
}
