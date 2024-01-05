import 'package:responsive_list_detail/features/entry_details/entry_details_screen.dart';
import 'package:responsive_list_detail/features/entry_list/entry_list_screen.dart';
import 'package:responsive_list_detail/features/navi_rail/nav_rail_shell.dart';
import 'package:responsive_list_detail/features/navigation/responsive_route.dart';
import 'package:responsive_list_detail/features/utils/placeholder_screens.dart';
import 'package:tree_router/srs/base/tree_router.dart';
import 'package:tree_router/srs/tree/named_route.dart';
import 'package:tree_router/srs/tree/shell_route.dart';
import 'package:tree_router/tree_router.dart';

final router = TreeRouter(
  initialRoute: EmailListScreen.name,
  routes: [
    ShellRoute(
      shellBuilder: (context, controller, child) {
        return NavRailShell(
          controller: controller,
          child: child,
        );
      },
      tabs: [
        ResponsiveRoute(
          screenBuilder: (context) {
            return const EmailListScreen();
          },
          name: EmailListScreen.name,
          children: [
            ValueRoute<EmailRouteData>(
              screenBuilder: (context, value) {
                return EmailDetailsScreen(data: value);
              },
            ),
          ],
        ),
        NamedRoute(
          screenBuilder: (context) => const PlaceholderScreen(),
          name: PlaceholderScreen.route1,
        ),
        NamedRoute(
          screenBuilder: (context) => const PlaceholderScreen(),
          name: PlaceholderScreen.route2,
        ),
        NamedRoute(
          screenBuilder: (context) => const PlaceholderScreen(),
          name: PlaceholderScreen.route3,
        ),
      ],
    ),
  ],
);
