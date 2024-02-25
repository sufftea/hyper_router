import 'package:flutter/material.dart';
import 'package:hyper_router/hyper_router.dart';
import 'package:provider/provider.dart';
import 'screens/second_tab_screen.dart';
import 'screens/value_screen.dart';
import 'state/auth_state.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/tabs_shell.dart';

HyperRouter createRouter() {
  return HyperRouter(
    initialRoute: HomeScreen.routeName,
    redirect: (context, state) {
      final authenticated =
          context.read<ValueNotifier<AuthState>>().value.authenticated;

      if (!authenticated) {
        return LoginScreen.routeName;
      }

      return null;
    },
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
                ValueRoute<SomeValue>(
                  screenBuilder: (context, value) => ValueScreen(value: value),
                ),
              ]),
          NamedRoute(
            screenBuilder: (context) => const SecondTabScreen(),
            name: SecondTabScreen.routeName,
          ),
        ],
      ),
      NamedRoute(
        screenBuilder: (context) => const LoginScreen(),
        name: LoginScreen.routeName,
      ),
    ],
  );
}
