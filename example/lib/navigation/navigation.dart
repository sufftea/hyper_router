import 'package:example/screens/home/home_screen.dart';
import 'package:example/screens/profile/profile_screen.dart';
import 'package:example/screens/search/search_screen.dart';
import 'package:example/screens/search_result/search_result_name.dart';
import 'package:example/screens/shell_tab_bar/shell_tab_bar_screen.dart';
import 'package:flutter_stack_router/srs/destination/shell_destination.dart';
import 'package:flutter_stack_router/stack_router.dart';

final router = StackRouter(
  initialDestination: HomeScreen.routeValue,
  destinations: [
    ShellDestination(
      tabs: [
        NamedDestination(
          screenBuilder: (context) => const HomeScreen(),
          nameKey: HomeScreen.routeValue,
        ),
        NamedDestination(
          screenBuilder: (context) => SearchScreen(),
          nameKey: SearchScreen.routeValue,
          children: [
            ValueDestination<SearchResultScreenData>(
              screenBuilder: (context, value) =>
                  SearchResultScreen(data: value),
            ),
          ],
        ),
        NamedDestination(
          screenBuilder: (context) => const ProfileScreen(),
          nameKey: ProfileScreen.routeName,
        ),
      ],
      shellBuilder: (context, controller, child) {
        return ShellTabBarScreen(
          tabController: controller,
          child: child,
        );
      },
    ),
  ],
);
