import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/destination/shell_destination.dart';
import 'package:flutter_stack_router/srs/internal/destination_mapper.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';
import 'package:flutter_stack_router/stack_router.dart';

class NestedStackRouter extends StatelessWidget {
  NestedStackRouter({
    required this.stack,
    required List<Destination> destinations,
    super.key,
  }) {
    _mapper = DestinationMapper(roots: destinations);
  }

  late final DestinationMapper _mapper;
  final List<DestinationValue> stack;

  @override
  Widget build(BuildContext context) {
    final parentRouter = StackRouter.configOf(context);

    return Navigator(
      pages: _mapper.mapStack(context, RouteStack(stack)),
      onPopPage: (route, result) {
        return true;
      },
    );
    // final config = StackRouter(
    //   initialStack: stack,
    //   destinations: _mapper.roots,
    //   backButtonDispatcher: ChildBackButtonDispatcher(
    //     parentRouter.backButtonDispatcher,
    //   )..takePriority(),
    // );

    // return Router.withConfig(
    //   config: config,
    // );
  }
}
