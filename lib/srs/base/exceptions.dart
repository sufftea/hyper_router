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


