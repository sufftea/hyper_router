import 'package:flutter/material.dart';

class CustomTransitionPage<T> extends Page<T> {
  const CustomTransitionPage({
    required this.child,
    required this.transitionBuilder,
    this.maintainState = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    Duration? reverseTransitionDuration,
    this.barrierColor,
    this.barrierLabel,
    super.key,
  }) : reverseTransitionDuration =
            reverseTransitionDuration ?? transitionDuration;

  final Color? barrierColor;
  final String? barrierLabel;
  final bool maintainState;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;

  final Widget child;

  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) transitionBuilder;

  @override
  Route<T> createRoute(BuildContext context) {
    return CustomTransitionPageRoute<T>(this);
  }
}

class CustomTransitionPageRoute<T> extends PageRoute<T> {
  CustomTransitionPageRoute(CustomTransitionPage<T> page)
      : super(settings: page);

  CustomTransitionPage<T> get page => settings as CustomTransitionPage<T>;

  @override
  Color? get barrierColor => page.barrierColor;

  @override
  String? get barrierLabel => page.barrierLabel;

  @override
  bool get maintainState => page.maintainState;

  @override
  Duration get transitionDuration => page.transitionDuration;

  @override
  Duration get reverseTransitionDuration => page.reverseTransitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return page.child;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return page.transitionBuilder(
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}

class NoAnimationPageRoute extends CustomTransitionPage {
  const NoAnimationPageRoute({
    required super.child,
    super.maintainState = true,
    super.barrierColor,
    super.barrierLabel,
    super.key,
  }) : super(
          transitionBuilder: _transitionBuilder,
          transitionDuration: const Duration(microseconds: 1),
        );

  static Widget _transitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
