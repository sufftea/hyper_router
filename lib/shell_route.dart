import 'package:flutter/material.dart';
import 'package:flutter_stack_router/stack_router.dart';

class NestedNavigator extends StatelessWidget {
  const NestedNavigator({
    required this.controller,
    super.key,
  });

  final StackRouterControllerBase controller;

  @override
  Widget build(BuildContext context) {
    debugPrint('building nestedNavigator');
    final parentRouter = StackRouter.of(context);

    final config = StackRouter(
      controller: controller,
      destinationMapper: parentRouter.destinationMapper,
      backButtonDispatcher: ChildBackButtonDispatcher(
        parentRouter.backButtonDispatcher,
      )..takePriority(),
    );

    return Router.withConfig(
      config: config,
    );
  }
}
