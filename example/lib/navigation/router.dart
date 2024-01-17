import 'package:example/screens/home/home_screen.dart';
import 'package:example/screens/number_screens/number_screens.dart';
import 'package:example/screens/profile/profile_screen.dart';
import 'package:example/screens/random/random_screen.dart';
import 'package:example/screens/search/search_screen.dart';
import 'package:example/screens/search_result/search_result_name.dart';
import 'package:example/screens/shell_tab_bar/shell_tab_bar_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fractal_router/fractal_router.dart';

final authStateProvider = StateProvider((ref) => false);

final router = FractalRouter(
  initialRoute: HomeScreen.routeValue,
  redirect: (context, stack) {
    final target = stack.last();

    final authenticated =
        ProviderScope.containerOf(context).read(authStateProvider);

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
          screenBuilder: (context) => const RandomScreen(),
          name: RandomScreen.routeValue,
        ),
      ],
    ),
  ],
);
