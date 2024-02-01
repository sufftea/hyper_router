import 'package:flutter/material.dart';
import 'package:star/srs/route/star_route.dart';

class StarStateBuilder extends StatelessWidget {
  const StarStateBuilder({
    required this.stack,
    required this.builder,
    required this.onRouteChange,
    super.key,
  });

  final Widget Function(BuildContext context, List<Page> pages) builder;
  final void Function(BuildContext context, RouteNode stack) onRouteChange;
  final RouteNode stack;

  @override
  Widget build(BuildContext context) {
    return _InheritedStack(
      stack: stack,
      child: _StateWatcher(
        onRouteChange: onRouteChange,
        builder: builder,
      ),
    );
  }
}

class _StateWatcher extends StatefulWidget {
  const _StateWatcher({
    required this.onRouteChange,
    required this.builder,
  });

  final Widget Function(BuildContext context, List<Page> pages) builder;
  final void Function(BuildContext context, RouteNode stack) onRouteChange;

  @override
  State<_StateWatcher> createState() => _StateWatcherState();
}

class _StateWatcherState extends State<_StateWatcher> {
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

    widget.onRouteChange(context, stack);
  }

  @override
  Widget build(BuildContext context) {
    final stack =
        context.dependOnInheritedWidgetOfExactType<_InheritedStack>()!.stack;

    return Builder(builder: (context) {
      return widget.builder(context, stack.createPages(context));
    });
  }
}

class _InheritedStack extends InheritedWidget {
  const _InheritedStack({
    required this.stack,
    required super.child,
  });

  final RouteNode stack;

  @override
  bool updateShouldNotify(_InheritedStack oldWidget) {
    return stack != oldWidget.stack;
  }
}
