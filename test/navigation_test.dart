import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyper_router/srs/base/hyper_build_context.dart';
import 'package:provider/provider.dart';

import 'base/screens/second_tab_screen.dart';
import 'base/screens/tabs_shell.dart';
import 'base/screens/value_screen.dart';
import 'base/state/auth_state.dart';
import 'base/router.dart';
import 'base/screens/home_screen.dart';
import 'base/screens/login_screen.dart';

void main() {
  testWidgets(
    'Redirect callback',
    (widgetTester) async {
      final router = createRouter();

      await widgetTester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => ValueNotifier(AuthState(false)),
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await widgetTester.pumpAndSettle();
      expect(
        find.byType(LoginScreen).hitTestable(),
        findsOneWidget,
        reason: 'Redirects to login screen on initialization',
      );

      final loginContext = widgetTester.firstElement(find.byType(LoginScreen));

      loginContext.read<ValueNotifier<AuthState>>().value = AuthState(true);
      loginContext.hyper.navigate(HomeScreen.routeName);

      await widgetTester.pumpAndSettle();
      expect(find.byType(HomeScreen).hitTestable(), findsOneWidget,
          reason: 'Navigate to home screen after authentication');
    },
  );

  testWidgets(
    'ValueRoute',
    (widgetTester) async {
      final router = createRouter();

      await widgetTester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => ValueNotifier(AuthState(true)),
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      final homeContext =
          widgetTester.firstElement(find.byType(HomeScreen).hitTestable());
      const value = 'value-route-test';
      homeContext.hyper.navigate(SomeValue(value));

      await widgetTester.pumpAndSettle();
      expect(
        widgetTester
            .firstWidget<ValueScreen>(find.byType(ValueScreen))
            .value
            .value,
        value,
      );
    },
  );

  testWidgets(
    'ShellRoute',
    (widgetTester) async {
      final router = createRouter();

      await widgetTester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => ValueNotifier(AuthState(true)),
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      final homeContext = widgetTester.firstElement(find.byType(HomeScreen));
      homeContext.hyper.navigate(SomeValue(''));
      await widgetTester.pumpAndSettle();
      expect(
        find.byType(ValueScreen),
        findsOneWidget,
        reason: 'Navigating to a subroute before switching the tab',
      );

      widgetTester
          .firstWidget<TabsShell>(find.byType(TabsShell))
          .controller
          .setTabIndex(1);
      await widgetTester.pumpAndSettle();

      expect(find.byType(SecondTabScreen).hitTestable(), findsOneWidget,
          reason: 'Navigates to another tab');

      widgetTester
          .firstWidget<TabsShell>(find.byType(TabsShell))
          .controller
          .setTabIndex(0);

      await widgetTester.pumpAndSettle();
      expect(
        find.byType(ValueScreen),
        findsOneWidget,
        reason: 'Preserves the state of other tabs',
      );
    },
  );
}
