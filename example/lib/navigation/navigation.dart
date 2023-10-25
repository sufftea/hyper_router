import 'package:example/screens/home/home_screen.dart';
import 'package:example/screens/post/post_screen.dart';
import 'package:example/screens/profile/profile_screen.dart';
import 'package:example/screens/settings/settings_screen.dart';
import 'package:example/screens/tab_bar/tab_bar_screen.dart';
import 'package:flutter_stack_router/destination.dart';
import 'package:flutter_stack_router/route_stack.dart';
import 'package:flutter_stack_router/stack_router.dart';

final router = StackRouter(
  controller: StackRouterController(
    initialStack: RouteStack([const HomeRouteData()]),
  ),
  destinations: [
    ScreenDestination<HomeRouteData>(screenBuilder: (context, value) {
      return const HomeScreen();
    }),
    ScreenDestination<PostRouteData>(screenBuilder: (context, value) {
      return PostScreen(data: value);
    }),
    ScreenDestination<SettingsRouteData>(screenBuilder: (context, value) {
      return const SettingsScreen();
    }),
    ScreenDestination<TabBarRouteData>(screenBuilder: (context, value) {
      return TabBarScreen(
        data: value,
      );
    }),
    ScreenDestination<ProfileRouteData>(screenBuilder: (context, value) {
      return const ProfileScreen();
    }),
  ],
);

class MyRoutes {
  static final home = RouteStack([
    const HomeRouteData(),
  ]);

  static RouteStack profile(String userId) => RouteStack([
        const HomeRouteData(),
        PostRouteData(userId),
      ]);
}
