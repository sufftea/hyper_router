class StarError extends Error {
  StarError(this.message);
  final String message;

  @override
  String toString() {
    return "starError: $message";
  }
}
