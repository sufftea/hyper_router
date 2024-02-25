import 'package:hyper_router/srs/route/shell_route/shell_value.dart';
import 'package:hyper_router/hyper_router.dart';

class ShellController {
  ShellController({
    required this.value,
    required this.controller,
  });

  final ShellValue value;
  int get tabIndex => value.tabIndex;

  RouteNode get root => value.tabNodes[value.tabIndex];

  final RootHyperController controller;

  /// [preserveState] behaviour:
  ///   `true`: subroutes within each tab are preserved
  ///   `false`: resets each tab to the first route.
  ///   `null` (default): preserves state when switching tabs; resets to the first
  ///     route when activating the same tab again.
  void setTabIndex(int index, {bool? preserveState}) {
    final ShellValue updatedValue;

    if (preserveState == null || preserveState == true) {
      if (index != value.tabIndex) {
        updatedValue = value.withIndex(index);
      } else {
        final next = value.tabNodes[index];
        updatedValue = value.withNext(
          next.route.updateWithNext(
            next: null,
            value: next.value,
          ),
        );
      }
    } else {
      final next = value.tabNodes[index];
      updatedValue = value.withNext(
        next.route.updateWithNext(
          next: null,
          value: next.value,
        ),
      );
    }

    controller.setStack(
      controller.stack.withUpdatedValue(
        value.key,
        updatedValue,
      ),
    );
  }
}
