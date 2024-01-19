import 'package:example/screens/home/home_screen.dart';
import 'package:example/screens/number_screens/number_screens.dart';
import 'package:example/screens/profile/profile_screen.dart';
import 'package:example/screens/random/random_screen.dart';
import 'package:example/screens/search/search_screen.dart';
import 'package:example/screens/search_result/search_result_name.dart';
import 'package:example/screens/shell_tab_bar/shell_tab_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:fractal_router/fractal_router.dart';
import 'package:provider/provider.dart';

final router = FractalRouter(
  initialRoute: HomeScreen.routeValue,
  redirect: (context, stack) {
    final target = stack.last();

    final authenticated = Provider.of<ValueNotifier<bool>>(context).value;

    if (target.key == LogOutScreen.routeName.key && !authenticated) {
      return SearchScreen.routeValue;
    }

    return null;
  },
  routes: [
    ShellRoute(
      shellBuilder: (context, controller, child) {
        return ShellTabBarScreen(
          controller: controller,
          child: child,
        );
      },
      tabs: [
        NamedRoute(
            screenBuilder: (context) => const HomeScreen(),
            name: HomeScreen.routeValue,
            children: [
              ShellRoute(
                shellBuilder: (context, controller, child) {
                  return ShellTabBarScreen(
                    controller: controller,
                    child: child,
                  );
                },
                tabs: [
                  NamedRoute(
                    screenBuilder: (context) => const LogOutScreen(),
                    name: LogOutScreen.routeName,
                  ),
                  NamedRoute(
                    screenBuilder: (context) => const SomeScreen(),
                    name: SomeScreen.routeName2,
                  ),
                  NamedRoute(
                    screenBuilder: (context) => const PopMeScreen(),
                    name: PopMeScreen.routeName,
                  ),
                ],
              ),
            ]),
        NamedRoute(
          screenBuilder: (context) => SearchScreen(),
          name: SearchScreen.routeValue,
          children: [
            ValueRoute<SearchResultScreenData>(
              screenBuilder: (context, value) =>
                  SearchResultScreen(data: value),
              children: [
                NamedRoute(
                  screenBuilder: (context) {
                    return const SomeScreen();
                  },
                  name: SomeScreen.routeName3,
                ),
              ],
            ),
          ],
        ),
        NamedRoute(
          screenBuilder: (context) => const ProfileScreen(),
          name: ProfileScreen.routeName,
        ),
      ],
      onTop: [
        NamedRoute(
          screenBuilder: (context) => PlaceholderScreen(
            name: '1',
            buttons: [
              ElevatedButton(
                onPressed: () async {
                  final result = await context.frouter.push(PlaceholderScreen.name2);
                  debugPrint('pop result: $result');
                },
                child: const Text('push dialog'),
              ),
            ],
          ),
          name: PlaceholderScreen.name1,
          children: [
            NamedRoute(
              screenBuilder: (context) => PlaceholderScreen(
                name: '2',
                buttons: [
                  ElevatedButton(
                    onPressed: () {
                      context.frouter.pop('12345');
                    },
                    child: const Text('pop'),
                  ),
                ],
              ),
              name: PlaceholderScreen.name2,
            ),
          ],
        ),
      ],
    ),
  ],
);

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.name,
    required this.buttons,
    super.key,
  });

  static const name1 = RouteName('1');
  static const name2 = RouteName('2');
  static const name3 = RouteName('3');

  final String name;
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name),
            ...buttons,
          ],
        ),
      ),
    );
  }
}
