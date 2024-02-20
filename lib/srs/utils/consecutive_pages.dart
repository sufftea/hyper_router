Iterable<T> followByIterable<T>(
  T value,
  Iterable<T>? followedBy,
) {
  return [value].followedBy(followedBy ?? []);
}
