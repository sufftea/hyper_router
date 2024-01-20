import 'package:example/features/guide/guide_screen.dart';
import 'package:example/features/home/home_screen.dart';
import 'package:example/features/internals/internal_screen.dart';
import 'package:example/features/tabs/tabs_shell.dart';
import 'package:snowflake_route/srs/base/snowflake.dart';
import 'package:snowflake_route/srs/route/named_route.dart';
import 'package:snowflake_route/srs/route/shell_route.dart';

final router = Snowflake(
  initialRoute: HomeScreen.routeName,
  routes: [
    ShellRoute(
      shellBuilder: (context, controller, child) =>
          TabsShell(controller: controller, child: child),
      tabs: [
        NamedRoute(
          screenBuilder: (context) => const HomeScreen(),
          name: HomeScreen.routeName,
        ),
        NamedRoute(
          screenBuilder: (context) => const GuideScreen(),
          name: GuideScreen.routeName,
        ),
        NamedRoute(
          screenBuilder: (context) => const InsideScreen(),
          name: InsideScreen.routeName,
        ),
      ],
    ),
  ],
);
