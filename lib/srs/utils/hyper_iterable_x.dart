extension HyperIterableX<T> on Iterable<T> {
  Iterable<T> followedByOptional(Iterable<T>? other) {
    if (other == null) {
      return this;
    }
    return followedBy(other);
  }
}
