Iterable<T> consecutive<T>(
  T value,
  Iterable<T>? followedBy,
) {
  return [value].followedBy(followedBy ?? []);
}
