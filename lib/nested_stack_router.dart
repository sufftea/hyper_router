import 'package:flutter/material.dart';
import 'package:flutter_stack_router/stack_router.dart';

class NestedStackRouter extends StatelessWidget {
  const NestedStackRouter({
    required this.controller,
    super.key,
  });

  final StackRouterControllerBase controller;

  @override
  Widget build(BuildContext context) {
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
