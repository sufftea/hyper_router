import 'package:example/screens/home/home_screen.dart';
import 'package:example/screens/profile/profile_screen.dart';
import 'package:example/screens/random/random_screen.dart';
import 'package:example/screens/search/search_screen.dart';
import 'package:example/screens/search_result/search_result_name.dart';
import 'package:example/screens/shell_tab_bar/shell_tab_bar_screen.dart';
import 'package:flutter_stack_router/my_router.dart';

final router = MyRouter(
  initialRoute: HomeScreen.routeValue,
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
        ),
        NamedRoute(
          screenBuilder: (context) => SearchScreen(),
          name: SearchScreen.routeValue,
          children: [
            ValueRoute<SearchResultScreenData>(
              screenBuilder: (context, value) =>
                  SearchResultScreen(data: value),
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
