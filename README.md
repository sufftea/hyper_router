# Star

Value-based router for Flutter.

## Features

- **Value-based navigation:** To navigate to a route, pass a value of it's associated type to the navigator. This value can contain the data you want to pass to the route.
- **Declarative:** Route tree configuration; navigation to a specific location in the tree.
- **Guards**: Redirect on route change.
- **Nested navigation** There is a built in `ShellRoute`. Supports preserving the stack when switching tabs.
- **Return value from a route** 
- **Custom routes**: Override built in classes for specialized use-cases.
- **WEB SUPPORT IS INCOMING** 

## Overview

1) Declare the route tree. Each node in the tree has an associated "key": it can be either a specific object (`RouteName`), or a type (`RouteValue`).  Keys must be unique.
2) Access the controller with `Star.of(context)` or `context.star`.
3) To navigate to a specific location in the tree, use the key associated with that location: `context.star.navigate(<key>)`.
4) To pop a route, use `context.star.pop` or the default `Navigator.of(context).pop`.
5) Star enforces the declared route tree, preventing navigation to routes that are not explicitly defined. (Unless you're using the native flutter API, which you still can. For example, to show dialogs).


## Route tree configuration
```dart
final router = Star(
  initialRoute: HomeScreen.routeName,
  routes: [
    ShellRoute(
      shellBuilder: (context, controller, child) => TabsShell(
        controller: controller,
        child: child,
      ),
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
                  screenBuilder: (context, value) => ProductDetailsScreen(
                    value: value,
                  ),
                ),
              ],
            ),
          ],
        ),
        NamedRoute(
          screenBuilder: (context) => const CartScreen(),
          name: CartScreen.routeName,
        ),
        NamedRoute(
          screenBuilder: (context) => const SettingsScreen(),
          name: SettingsScreen.routeName,
        ),
      ],
    ),
    NamedRoute(
      screenBuilder: (context) => const AuthScreen(),
      name: AuthScreen.routeName,
    ),
  ],
);
```
Notice the 3 types of routes:
- `NamedRoute`
- `ValueRoute<T>`
- `ShellRoute`


### NamedRoute

The most common kind of a route. `routeName` is the key that will be used to navigate to this location. 

Declaring the route name:
```dart
class HomeScreen extends StatelessWidget {
  static const routeName = RouteName('home');
  // ...
}
```
Navigating:
```dart
Star.of(context).navigate(HomeScreen.routeName); 
// context.star.navigate(HomeScreen.routeName); // quicker way
```

### ValueRoute\<T\>

A route you can pass a value to. The type `T` is the key associated with the route. It can contain any data you want to pass to the route.

Declaring the type:
```dart
class ProductRouteValue extends RouteValue {
  const ProductRouteValue(this.product);
  final Product product;
}
```
Navigating:
```dart
context.star.navigate(ProductRouteValue(
  Product(/*...*/)
)); 
```

### ShellRoute

arguments:
- `shellBuilder`: the screen that wraps the child route and displays the tab bar.
- `tabs`: the routes that can be displayed inside the shell. 
- Optionally, you can display a route on top of the shell, by placing it inside the `onTop` field.

The shell is provided with a `ShellController`. You can use it to switch between the tabs (`setTabIndex(index)`) and get the current tab index (`tabIndex`). The tab indexes are their indexes in the `tabs` field. Alternatively, it's still possible to navigate to the tabs the regular way by using `navigate`.

Internally, `ShellRoute` also has a key associated with it that stores the state of each tab.

Example:
```dart
import 'package:flutter/material.dart';
import 'package:star/star.dart';

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

It's the same as everywhere else: 
```dart
final result = await context.star.navigate(FormScreen.routeName);
```
```dart
// FormScreen
context.star.pop(value);
```
Or you can use the native flutter push. For example, to show a dialog:
```dart
final result = await showDialog(Dialog(...));
```
```dart
// Dialog
Navigator.of(context).pop(value);
// context.star.pop(value) // will also work
```
Such routes are not reflected in Star's internal state, so they can't use any of the perks provided by the package.

## Guards

You can add a redirect callback that is triggered every time the route changes and redirects to a different screen if necessary.

For example, you might want to check if the user is logged in, and if not, redirect them to the login page:
```dart
final router = Star(
  redirect: (context, stack) {
    if (stack.containsNode(AuthwalledScreen.routeName.key)) {
      if (!context.watch<AuthCubit>().state.authenticated) {
        return AuthRouteValue(stack.last().value);
      }
    }

    return null;
  },
  // ...
);
```
- `stack` is a linked list of all the route nodes that are about to be displayed. The first element is the root route, the last is the route that's going to be at the top.
- `containsNode` returns `true` if a route with the provided key is somewhere in the stack. Notice that it requires providing the `key` explicitly. 
  - `RouteName`'s key is the string you provide when you initialize it.
  - `RouteValue`'s key is its type.
- It is possible to subscribe to the context inside the callback. This way you can redirect as soon as the condition changes, instead fo waiting for the user to try to change the route.
- Return the value associated with the route you want to redirect to. This is the same value you would use for navigation. If no redirect is needed, return null.
- `stack.last().value` is the value associated with the route the user was trying to navigate to. We're passing it into the auth screen, so that it can navigate to the desired route after the authentication is finished.

## Creating a custom route

I tried to make the package really extensible, so it's possible to create a route for any specialized use-case. In the [demo app](https://github.com/sufftea/star/tree/concept/example), I created a responsive [list-detail view](https://m3.material.io/foundations/layout/canonical-layouts/list-detail): it displays the list and the detail pages side by side on a wide screen (similarly to a shell route), and regularly on top of each other on a small screen. 

How the router works on the inside:

1) The route tree is traversed from the target route to the root to construct a linked list of `RouteNode`s.
2) Each node is responsible for building its own page and (recursively) all the consecutive pages. This happens inside the `createPages` method that returns the list of pages.
    - `NamedRoute` and `ValueRoute` just place their own and all the consecutive pages on top of each other:
      ```dart
      List<Page> createPages(BuildContext context) {
        final page = buildPage(context);

        return [
          page,
          ...next?.createPages(context) ?? [],
        ];
      }
      ```
    - `ShellRoute` only places its own page into the list, while all its children go into the nested navigator inside the shell page.
3) To create your own route, you need to override these two classes: `StarRoute` and `RouteNode`. 

This should be enough to understand the example from [the demo](https://github.com/sufftea/star/tree/concept/example).



  
  
  
  

