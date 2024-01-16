import 'package:example/features/home/home_screen.dart';
import 'package:example/features/tabs/tabs_shell.dart';
import 'package:fractal_router/fractal_router.dart';

final router = FractalRouter(
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
      ],
    ),
  ],
);
