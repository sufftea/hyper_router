import 'package:flutter/material.dart';
import 'package:fractal_router/srs/base/nested_navigator.dart';
import 'package:responsive_list_detail/features/utils/screen_sizes.dart';
import 'package:fractal_router/fractal_router.dart';

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
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context).colorScheme;

    return switch (size.width) {
      < mediumWidth => [
          MaterialPage(child: buildScreen(context)),
          ...next?.createPages(context) ?? [],
        ],
      _ => [
          MaterialPage(
            child: Container(
              color: theme.surfaceVariant,
              child: Row(
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    child: SizedBox(
                      width: 400,
                      child: buildScreen(context),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: NestedNavigator(
                        pages: [
                          const MaterialPage(
                            child: Scaffold(
                              body: Center(
                                child: Text('empty'),
                              ),
                            ),
                          ),
                          ...next?.createPages(context) ?? [],
                        ],
                      ),
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
    return ResponsivePageBuilder(
      buildPage: buildPage,
      next: next?.pop(),
      value: value,
      buildScreen: buildScreen,
    );
  }
}
