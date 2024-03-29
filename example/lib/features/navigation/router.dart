import 'package:example/features/demos/custom_route/email_detail_screen.dart';
import 'package:example/features/demos/custom_route/email_list_screen.dart';
import 'package:example/features/demos/custom_route/responsive_route.dart';
import 'package:example/features/demos/dialog/dialog_examples_screen.dart';
import 'package:example/features/demos/dialog/dialog_screen.dart';
import 'package:example/features/demos/guard/auth_screen.dart';
import 'package:example/features/demos/guard/authwalled_screen.dart';
import 'package:example/features/demos/guard/create_post_screen.dart';
import 'package:example/features/demos/guard/state/auth_cubit.dart';
import 'package:example/features/demos/nested_routes/chat_screen.dart';
import 'package:example/features/demos/nested_routes/demo_tabs_shell.dart';
import 'package:example/features/demos/nested_routes/docs_screen.dart';
import 'package:example/features/demos/nested_routes/inbox_screen.dart';
import 'package:example/features/demos/nested_routes/inbox_subroute_screen.dart';
import 'package:example/features/demos/nested_routes/on_top_screen.dart';
import 'package:example/features/demos/value_based/product_details/product_details_screen.dart';
import 'package:example/features/demos/value_based/product_list/product_list_screen.dart';
import 'package:example/features/error/error_screen.dart';
import 'package:example/features/guide/guide_screen.dart';
import 'package:example/features/home/home_screen.dart';
import 'package:example/features/internals/internal_screen.dart';
import 'package:example/features/tabs/main_tabs_shell.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hyper_router/hyper_router.dart';

final _demoShellKey = RouteKey();

final router = HyperRouter(
  initialRoute: HomeScreen.routeName,
  enableUrl: true,
  onException: (state) {
    if (state.exception is UrlParsingException) {
      return ErrorRouteValue(state.routeInformation);
    }
    return null;
  },
  redirect: (context, state) {
    final authCubit = context.read<AuthCubit>();
    if (!authCubit.state.authenticated &&
        state.stack.containsNode(AuthwalledScreen.routeName.key)) {
      return AuthRouteValue(state.stack.last().value);
    }

    return null;
  },
  routes: [
    ShellRoute(
      shellBuilder: (context, controller, child) =>
          MainTabsShell(controller: controller, child: child),
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
                  urlParser: ProductSegmentParser(),
                ),
              ],
            ),
            NamedRoute(
              screenBuilder: (context) => const AuthwalledScreen(),
              name: AuthwalledScreen.routeName,
              children: [
                NamedRoute(
                  screenBuilder: (context) => const CreatePostScreen(),
                  name: CreatePostScreen.routeName,
                ),
              ],
            ),
            ValueRoute<AuthRouteValue>(
              screenBuilder: (context, value) => AuthScreen(value: value),
              urlParser: AuthSegmentParser(),
            ),
            NamedRoute(
              screenBuilder: (context) => const DialogExamplesScreen(),
              name: DialogExamplesScreen.routeName,
              children: [
                NamedRoute(
                  screenBuilder: (context) => const DialogScreen(),
                  name: DialogScreen.routeName,
                ),
              ],
            ),
            ShellRoute(
              key: _demoShellKey,
              shellBuilder: (context, controller, child) => DemoTabsShell(
                controller: controller,
                child: child,
              ),
              tabs: [
                NamedRoute(
                  screenBuilder: (context) => const InboxScreen(),
                  name: InboxScreen.routeName,
                  children: [
                    NamedRoute(
                      screenBuilder: (context) => const InboxSubrouteScreen(),
                      name: InboxSubrouteScreen.routeName,
                    ),
                    ShellCoveringRoute(
                      shellKey: _demoShellKey,
                      children: [
                        NamedRoute(
                          screenBuilder: (context) => const CoveringScreen(),
                          name: CoveringScreen.routeName,
                        )
                      ],
                    ),
                  ],
                ),
                NamedRoute(
                  screenBuilder: (context) => const DocsScreen(),
                  name: DocsScreen.routeName,
                ),
                NamedRoute(
                  screenBuilder: (context) => const ChatScreen(),
                  name: ChatScreen.routeName,
                ),
              ],
            ),
            ResponsiveRoute(
              screenBuilder: (context) => const EmailListScreen(),
              name: EmailListScreen.routeName,
              children: [
                ValueRoute<EmailDetailRouteValue>(
                  screenBuilder: (context, value) => EmailDetailScreen(
                    value: value,
                  ),
                  urlParser: EmailDetailSegmentParser(),
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
    ValueRoute<ErrorRouteValue>(
      screenBuilder: (context, value) => ErrorScreen(value: value),
      urlParser: ErrorSegmentParser(),
    ),
  ],
);
