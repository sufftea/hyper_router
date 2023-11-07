import 'package:example/screens/home/home_screen.dart';
import 'package:example/screens/post/post_screen.dart';
import 'package:example/screens/profile/profile_screen.dart';
import 'package:example/screens/settings/settings_screen.dart';
import 'package:example/screens/tab_bar/tab_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/transitions/custom_transition_page.dart';
import 'package:flutter_stack_router/stack_router.dart';

final router = StackRouter(
  controller: StackRouterController(
    initialStack: RouteStack([const HomeRouteData()]),
  ),
  destinations: [
    ScreenDestination<HomeRouteData>(
      screenBuilder: (context, value) {
        return const HomeScreen();
      },
      pageBuilder: (context, child) {
        return NoAnimationPageRoute(child: child);
      },
    ),
    ScreenDestination<PostRouteData>(
      screenBuilder: (context, value) {
        return PostScreen(data: value);
      },
      pageBuilder: (context, child) {
        return CustomTransitionPage(
          child: child,
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            final position = Tween<Offset>(
              begin: const Offset(0, 1),
              end: const Offset(0, 0),
            ).chain(CurveTween(curve: Curves.easeOutQuad)).animate(animation);

            return SlideTransition(
              position: position,
              child: child,
            );
          },
        );
      },
    ),
    ScreenDestination<SettingsRouteData>(
      screenBuilder: (context, value) {
        return const SettingsScreen();
      },
    ),
    ScreenDestination<TabBarRouteData>(
      screenBuilder: (context, value) {
        return const TabBarScreen();
      },
    ),
    ScreenDestination<ProfileRouteData>(
      screenBuilder: (context, value) {
        return const ProfileScreen();
      },
      pageBuilder: (context, child) {
        return NoAnimationPageRoute(child: child);
      },
    ),
  ],
);
