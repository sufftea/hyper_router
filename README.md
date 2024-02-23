![img](example/assets/logo.png)

# HYPER_ROUTER

Value-BASED router for Flutter.

## Features

- **Value-based navigation:** navigate between app states using values, making the navigation type-safe.
- **Declarative**
- **Route guards**
- **Nested navigation**
- **Returning a value from a route:** pass data back to the originating screen when a route is popped.
- **Optional URL support:** implement URL parsing only when it's necessary.
- **Highly extensible**

## Overview

1) **Declare your route tree.** Each node in the tree is associated with a unique key.
2) **Access the controller:** Use `HyperRouter.of(context)` or `context.hyper` to interact with the router.
3) **Navigate:** Push new routes onto the stack using their associated keys with ``context.hyper.navigate(<key>)``.
4) **Pop routes:** Return to the previous screen using `context.hyper.pop` or `Navigator.of(context).pop`.

## Route tree configuration
```dart
final router = HyperRouter(
  initialRoute: HomeScreen.routeName,
  routes: [
    ShellRoute(
      shellBuilder: (context, controller, child) =>
          MainTabsShell(controller: controller, child: child),
      tabs: [
        NamedRoute(
          screenBuilder: (context) => const HomeScreen(),
          name: HomeScreen.routeName,
          children: [
            NamedRoute(
              screenBuilder: (context) => const ProductListScreen(),
              name: ProductListScreen.routeName,
              children: [
                ValueRoute<ProductRouteValue>(
                  screenBuilder: (context, value) =>
                      ProductDetailsScreen(value: value),
                ),
              ],
            ),
          ],
        ),
        NamedRoute(
          screenBuilder: (context) => const GuideScreen(),
          name: GuideScreen.routeName,
        ),
        NamedRoute(
          screenBuilder: (context) => const SettingsScreen(),
          name: SettingsScreen.routeName,
        ),
      ],
    ),
  ],
);
```
Notice the 3 types of routes:

- `NamedRoute`: A basic route, associated with a unique name.
- `ValueRoute<T>`: A route that lets you to pass data to another screen.
- `ShellRoute`: A route that wraps a nested navigator with an interface surrounding it, such as a tab bar.

The keys, associated with routes, are hidden in `RouteValue` instances:
- `RouteName` (for `NamedRoute`) uses the provided string as its key.
- Your custom type `T` for `ValueRoute<T>` uses `T` as the key.


### NamedRoute

Use for simple navigation between screens that doesn't require passing data.

1. Declare the route name:
```dart
class HomeScreen extends StatelessWidget {
  static const routeName = RouteName('home');
  // ...
}
```
2. Navigate:
```dart
HyperRouter.of(context).navigate(HomeScreen.routeName); 
// Or, for convenience:
// context.hyper.navigate(HomeScreen.routeName);
```

### ValueRoute\<T\>

Use a `ValueRoute<T>` if you need to pass data to the route during navigation.

1. Declare the value type by extending `RouteValue`:
```dart
class ProductRouteValue extends RouteValue {
  const ProductRouteValue(this.product);
  final Product product;
}
```
2. To navigate to the route, pass a value of your type to the navigator:
```dart
context.hyper.navigate(ProductRouteValue(
  Product(/*...*/)
)); 
```

### ShellRoute

Use `ShellRoute` to create a bottom navigation bar.

**Arguments:**
- `shellBuilder`: the screen that wraps the child route and displays the tab bar.
- `tabs`: the routes that will be displayed inside the shell. 

The shell builder is provided with a `ShellController`. 

**Using the `ShellController`:**
- `setTabIndex(index)`: Switch to the tab at the specified index.
- `tabIndex`: Get the index of the currently active tab.

> Btw: Internally, `ShellRoute`, like `ValueRoute`, also has a `RouteValue` associated with it that contains the state of each tab.

Example:
```dart
import 'package:flutter/material.dart';
import 'package:hyper_router/hyper_router.dart';

class TabsShell extends StatelessWidget {
  const TabsShell({
    required this.controller,
    required this.child,
    super.key,
  });

  final Widget child;
  final ShellController controller;

  @override
  Widget build(BuildContext context) {
    final i = controller.tabIndex;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          controller.setTabIndex(value);
        },
        selectedIndex: controller.tabIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(i == 0 ? Icons.home_outlined : Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(i == 1 ? Icons.shopping_bag_outlined : Icons.shopping_bag),
            label: "Cart",
          ),
          NavigationDestination(
            icon: Icon(i == 2 ? Icons.settings_outlined : Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
```

## Returning value from a route

Receiving the result:
```dart
final result = await context.hyper.navigate(FormScreen.routeName);
```
Returning the result:
```dart
// FormScreen
context.hyper.pop(value);
```
 
Native flutter push & pop work too. For example, showing a dialog:
```dart
final result = await showDialog(Dialog(...));
```
```dart
Navigator.of(context).pop(value);
```

## Guards

Use the riderect callback to control navigation flow based on conditions like authentication status:
```dart
final router = HyperRouter(
  redirect: (context, state) {
    final authCubit = context.read<AuthCubit>();

    // Check if user is logged in and trying to access an authenticated route
    if (!authCubit.state.authenticated &&
        state.stack.containsNode(AuthwalledScreen.routeName.key)) {
      return AuthScreen.routeName; // Redirect to authentication
    }

    return null; // No redirection needed
  },
  // ...
);
```
- `state.stack` Represents the upcoming navigation stack. The first element will be at the bottom, the last at the top.
- `stack.containsNode` Checks if a route with the provided key exists in the stack. Notice that it requires providing the `key` explicitly.
- Return:
  - The route key to redirect the user. This is the same value you would use for `navigate`.
  - `null`, if no redirect is necessary.

## Enable URL
There are two use-cases that require URL support: web apps and deep linking. Since most Flutter apps are targetting mobile platforms, and deep linking usually covers only a few destinations, HYPER_ROUTER was designed to make URL support optional.

### Web

By default, your app will work in the browser just fine, but the URL will not be updating. To fix that, set the `enableUrl` property to `true`:
```dart
final router = HyperRouter(
  enableUrl: true,
  // ...
);
```


> A segment is a part of the URL separated by a slash (`/`).

Now, you need to make sure that every route can be parsed to and from a URL segment. `NamedRoute` supports parsing by default, but `ValueRoute` needs to be provided with a parser. 

**Creating a URL parser:**

Here we're creating a parser for `ProductRouteValue`. We want the url to look like this: `home/products/<productID>`. The parser is responsible for the `<productId>` segment:
```dart
class ProductSegmentParser extends UrlSegmentParser<ProductRouteValue> {
  @override
  ProductRouteValue? decodeSegment(SegmentData segment) {
    return ProductRouteValue(segment.name);
  }

  @override
  SegmentData encodeSegment(ProductRouteValue value) {
    return SegmentData(name: value.productId);
  }
}
```
You can optionally provide query parameters to `SegmentData` (`queryParams` field). They will be placed at the end of the URL. If the stack contains more than one route with query parameters, they'll be combined.

`segment.state` is stored in the browser's history. You can put the data that you don't want visible in the URL there, and it will be restored when the user navigates using browser's back and forward buttons.

### Deep linking

TODO (although probably already possible)

## Creating a custom route

I tried to design the package to be highly extensible to make it possible to create a route for any werid and unusual use-case. As an example, in the [demo app](https://github.com/sufftea/hyper_router/tree/concept/example), I created a responsive [list-detail view](https://m3.material.io/foundations/layout/canonical-layouts/list-detail): it displays the list and the detail pages side by side on a wide screen (similarly to a shell route), and regularly, on top of each other, on a small screen. 

How the router works on the inside:

1) The route tree is traversed from the target route to the root to construct a linked list of `RouteNode`s.
2) Each node is responsible for building its own page and - recursively - all the consecutive pages. This happens inside the `createPages` method that returns the list of pages.
    - `NamedRoute` and `ValueRoute` just place their own and all the consecutive pages on top of each other:
      ```dart
      Iterable<Page> createPages(BuildContext context) {
        final page = buildPage(context);
        return [page].followedByOptional(next?.createPages(context));
      }
      ```
    - `ShellRoute` only places its own page into the list, while all its children go into the nested navigator inside the shell page.
3) To create your own route, you need to override these two classes: `HyperRoute` and `RouteNode`. 

This should be enough to understand the example from [the demo](https://github.com/sufftea/hyper_router/tree/concept/example).



  
  
  
  

