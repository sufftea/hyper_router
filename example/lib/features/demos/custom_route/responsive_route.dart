import 'package:example/features/utils/context_x.dart';
import 'package:example/features/utils/screen_sizes.dart';
import 'package:flutter/material.dart';
import 'package:snowflake_route/srs/base/nested_navigator.dart';
import 'package:snowflake_route/snowflake_route.dart';

class ResponsiveRoute extends NamedRoute {
  ResponsiveRoute({
    required super.screenBuilder,
    required super.name,
    super.children,
  });

  @override
  PageBuilder<RouteValue> createBuilder({
    PageBuilder<RouteValue>? next,
    RouteName? value,
  }) {
    return ResponsivePageBuilder(
      next: next,
      value: name,
      buildPage: (context) => buildPage(context, name),
      buildScreen: (context) => screenBuilder(context, name),
    );
  }
}

class ResponsivePageBuilder extends ValuePageBuilder {
  ResponsivePageBuilder({
    required super.buildPage,
    required super.next,
    required super.value,
    required this.buildScreen,
  });

  final Widget Function(BuildContext context) buildScreen;

  @override
  List<Page> createPages(BuildContext context) {
    return switch (context.width) {
      < mediumWidth => [
          MaterialPage(
            child: buildScreen(context),
          ),
          ...next?.createPages(context) ?? [],
        ],
      _ => [
          MaterialPage(
            child: Container(
              color: context.col.background,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 400,
                    child: buildScreen(context),
                  ),
                  VerticalDivider(
                    color: context.col.onBackground,
                    thickness: 0.5,
                  ),
                  Expanded(
                    child: NestedNavigator(
                      pages: [
                        const MaterialPage(
                          child: Scaffold(
                            body: Center(
                              child: Text(
                                'empty',
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ...next?.createPages(context) ?? [],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
    };
  }

  @override
  PageBuilder<RouteValue>? pop() {
    if (next == null) {
      return null;
    }

    return ResponsivePageBuilder(
      buildPage: buildPage,
      next: next?.pop(),
      value: value,
      buildScreen: buildScreen,
    );
  }
}
