import 'dart:math';

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
import 'package:star/srs/route/shell_covering_route.dart';
import 'package:star/srs/url/url_parser.dart';
import 'package:star/srs/value/route_key.dart';
import 'package:star/star.dart';

final _demoShellKey = RouteKey();

final router = Star(
  initialRoute: HomeScreen.routeName,
  errorRoute: ErrorScreen.routeName,
  enableWeb: true,
  redirect: (context, stack) {
    final authCubit = context.read<AuthCubit>();
    if (!authCubit.state.authenticated &&
        stack.containsNode(AuthwalledScreen.routeName.key)) {
      return AuthRouteValue(stack.last().value);
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
                  urlParser: QueryParamsUrlParser(
                    encodeSegment: (value) => (value.productId, {}),
                    decodeSegment: (segment, queryParams) =>
                        ProductRouteValue(segment),
                  ),
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
              urlParser: QueryParamsUrlParser(
                decodeSegment: (name, queryParams) => name == 'login'
                    ? AuthRouteValue(AuthwalledScreen.routeName)
                    : null,
                encodeSegment: (value) => ('login', {}),
              ),
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
                  urlParser: QueryParamsUrlParser(
                    encodeSegment: (value) => (
                      value.title
                          .substring(0, min(value.title.length, 16))
                          .replaceAll(' ', '-'),
                      {'id': value.emailId},
                    ),
                    decodeSegment: (name, queryParams) {
                      if (queryParams['id'] case final id?) {
                        return EmailDetailRouteValue(
                          emailId: id,
                          title: name,
                        );
                      } else {
                        return null;
                      }
                    },
                  ),
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
    NamedRoute(
      screenBuilder: (context) => const ErrorScreen(),
      name: ErrorScreen.routeName,
    ),
  ],
);
