import 'package:flutter/material.dart';
import 'package:snowflake_route/srs/base/root_controller.dart';
import 'package:snowflake_route/srs/base/snowflake.dart';
import 'package:snowflake_route/srs/route/flake_route.dart';

class RootNavigationStack extends StatelessWidget {
  const RootNavigationStack({
    required this.rootController,
    required this.builder,
    required this.redirect,
    super.key,
  });

  final Widget Function(BuildContext context, List<Page> pages) builder;
  final RedirectCallback redirect;
  final RootController rootController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: rootController,
      builder: (context, _) {
        return _InheritedStack(
          stack: rootController.stack,
          child: _RedirectWatcher(
            redirect: redirect,
            rootController: rootController,
            builder: builder,
          ),
        );
      },
    );
  }
}

class _RedirectWatcher extends StatefulWidget {
  const _RedirectWatcher({
    required this.redirect,
    required this.rootController,
    required this.builder,
  });

  final Widget Function(BuildContext context, List<Page> pages) builder;
  final RedirectCallback redirect;
  final RootController rootController;

  @override
  State<_RedirectWatcher> createState() => _RedirectWatcherState();
}

class _RedirectWatcherState extends State<_RedirectWatcher> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final stack =
        context.dependOnInheritedWidgetOfExactType<_InheritedStack>()!.stack;

    if (widget.redirect(context, stack) case final target?) {
      widget.rootController.navigateSilent(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.rootController.createPages(context));
  }
}

class _InheritedStack extends InheritedWidget {
  const _InheritedStack({
    required this.stack,
    required super.child,
  });

  final PageBuilder stack;

  @override
  bool updateShouldNotify(_InheritedStack oldWidget) {
    return stack != oldWidget.stack;
  }
}
