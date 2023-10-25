

### [WIP]
Value-based router for flutter.

## Features

- Value-based navigation: to push a route, give an object of the corresponding type to the router
- Type-safe (no dynamic arguments)
- Nested navigation
- State preservation between different tabs

TODO:
- Make state preservation optional
- Transition animations
- ?? Parsing urls
- Refactor
- lots of stuff


## Getting started

Declare a type associated with the screen. It can be anything: you can put the arguments required for the screen or just leave it empty:
```dart
class HomeRouteData {
  const HomeRouteData();
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ...
  }
}
```

Configure the router. The type argument you specify in `ScreenDestination` will be used to push that screen to the navigation stack:
```dart
final router = StackRouter(
  controller: StackRouterController(
    initialStack: RouteStack([const HomeRouteData()]),
  ),
  destinations: [
    ScreenDestination<HomeRouteData>(screenBuilder: (context, value) {
      return const HomeScreen();
    }),
  ],
);
```

## Usage

[the terminology is subject to change]

Instead of using strings to represent routes, Stack Router uses a list of objects, each representing a screen. When you push a new object to the list, the corresponding screen is pushed to the navigation stack. You define the mappings between the types and the screens in the router configuration as was shown above.

### Basic navigation

Accessing the router:
```dart
final routerState = StackRouter.stateOf(context);
```
All of those are equivalent:
```dart
routerState.push(const PostRouteData('content'));
// OR
routerState.controller.stack = RouteStack([
  routerState.localStack,
  const PostRouteData('content'),
]);
// OR
routerState.controller.stack = routerState.controller.stack
    .pushed(const PostRouteData('content'));
```
What's going on:
- `RouteStack` is just a wrapper around a list to prevent mutations and add convenience methods.
- `controller` manages the list of values and updates the router when it changes. It's the same controller that you pass into the `StackRouter` constructor, you can access it outside of the widget tree if you need to (this will become usefull when we get to nesting routers)
- `routerState.localStack` represents the current route regardless of whether there are other routes on top of it. This helps prevent pushing the same route on top twice when the user taps the button for the second time while the route is still animating in.

### Nesting routers (tab bar navigation)

There are two types of controllers: 
- `StackRouterController` - a regular controller, contains a single stack.
- `TabStackRouterController` - controller for managing multiple navigation stacks; use it for tab bar navigation.

1) Define the controller: 
    ```dart
    final controller = TabStackRouterController(
      initialTab: 1,
      tabs: [
        RouteStack([const ProfileRouteData()]),
        RouteStack([const HomeRouteData()]),
        RouteStack([const SettingsRouteData()]),
      ],
    );
    ```
2) Wrap the `NestedStackRouter` widget with any UI you need to navigate between the tabs:
    - `controller.tab` - get/set current tab index
    ```dart
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: NestedStackRouter(controller: controller),
        bottomNavigationBar: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return BottomNavigationBar(
              onTap: (value) {
                controller.tab = value;
              },
              currentIndex: controller.tab,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'profile'),
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'settings'),
              ],
            );
          },
        ),
      );
    }
    ```
