import 'package:example/features/demos/value_based/product_details/product_details_screen.dart';
import 'package:example/features/demos/value_based/product_list/product_list_screen.dart';
import 'package:example/features/guide/guide_screen.dart';
import 'package:example/features/home/home_screen.dart';
import 'package:example/features/internals/internal_screen.dart';
import 'package:example/features/tabs/tabs_shell.dart';
import 'package:snowflake_route/snowflake_route.dart';

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
          children: [
            NamedRoute(
              screenBuilder: (context) => const ProductListScreen(),
              name: ProductListScreen.routeName,
              children: [
                ValueRoute<ProductRouteValue>(
                  screenBuilder: (context, value) =>
                      ProductDetailsScreen(value: value),
                ),
              ],
            ),
          ],
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
