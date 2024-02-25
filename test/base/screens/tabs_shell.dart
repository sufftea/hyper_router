import 'package:flutter/material.dart';
import 'package:hyper_router/srs/route/shell_route/shell_controller.dart';

class TabsShell extends StatelessWidget {
  const TabsShell({
    required this.controller,
    required this.child,
    super.key,
  });

  final Widget child;
  final ShellController controller;

  @override
  Widget build(BuildContext context) {
    final i = controller.tabIndex;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          controller.setTabIndex(value);
        },
        selectedIndex: controller.tabIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(i == 0 ? Icons.inbox : Icons.inbox_outlined),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(i == 1 ? Icons.description : Icons.description_outlined),
            label: "Tab2",
          ),
        ],
      ),
    );
  }
}
