abstract class DestinationValue {
  const DestinationValue();

  Object get key => runtimeType;
}

/// Use for destinations that don't require parameters.
/// A convenience for not creating an empty class for each destination.
/// ```
/// class Routes {
///   static const home = DestinationName("home");
///   // ...
/// }
///   class HomeRoute extends DestinationValue {}
/// ```
/// then
/// ```
/// NamedDestination(
///   name: Routes.home,
///   // ...
/// )
/// ```
/// and then
/// ```
/// onPress: {
///   controller.navigate(Routes.home);
/// }
/// ```
class DestinationName extends DestinationValue {
  const DestinationName(this.name);

  final String name;

  @override
  Object get key => name;
}
