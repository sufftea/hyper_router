class RouteContext {
  RouteContext(this.map);

  final Map map;

  T getValue<T>() {
    return map[T] as T;
  }

  void setValue<T>(T value) {
    map[T] = value;
  }
}
