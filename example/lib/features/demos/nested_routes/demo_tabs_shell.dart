import 'package:flutter/material.dart';
import 'package:snowflake_route/snowflake_route.dart';

class DemoTabsShell extends StatelessWidget {
  const DemoTabsShell({
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
            icon: Icon(i == 0 ? Icons.inbox_outlined : Icons.inbox),
            label: "Inbox",
          ),
          NavigationDestination(
            icon: Icon(i == 1 ? Icons.description_outlined : Icons.description),
            label: "Docs",
          ),
          NavigationDestination(
            icon: Icon(i == 2 ? Icons.chat_bubble_outline : Icons.chat_bubble),
            label: "Chat",
          ),
        ],
      ),
    );
  }
}
