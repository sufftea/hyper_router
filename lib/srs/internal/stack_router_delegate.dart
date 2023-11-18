import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/destination/destination.dart';
import 'package:flutter_stack_router/srs/internal/destination_mapper.dart';
import 'package:flutter_stack_router/stack_router.dart';

class StackRouterDelegate extends RouterDelegate<RouteStack>
    with ChangeNotifier {
  StackRouterDelegate({
    required this.router,
    required this.controller,
    required this.destinationMapper,
  });

  final StackRouterController controller;
  final DestinationMapper destinationMapper;
  final StackRouter router;

  @override
  Widget build(BuildContext context) {
    return InheritedStackRouter(
      router: router,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Navigator(
            pages: destinationMapper.mapStack(context, controller.stack),
            onPopPage: (route, result) {
              return true;
            },
          );
        },
      ),
    );
  }

  @override
  Future<bool> popRoute() async {
    final currentDestinationValue = controller.stack.list.last;
    final currDestination =
        destinationMapper.findDestination(currentDestinationValue);

    final value = currDestination.onPop(currentDestinationValue);

    controller.stack = RouteStack([
      ...controller.stack.list.sublist(
        0,
        controller.stack.list.length - 1,
      ),
      if (value != null) value,
    ]);

    return controller.stack.list.isEmpty;
  }

  @override
  Future<void> setNewRoutePath(RouteStack configuration) {
    controller.stack = configuration;
    return SynchronousFuture(null);
  }

  @override
  Future<void> setInitialRoutePath(RouteStack configuration) {
    return setNewRoutePath(configuration);
  }
}
