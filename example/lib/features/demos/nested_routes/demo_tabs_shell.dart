import 'package:flutter/material.dart';
import 'package:star/star.dart';

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
            icon: Icon(i == 0 ? Icons.inbox : Icons.inbox_outlined),
            label: "Inbox",
          ),
          NavigationDestination(
            icon: Icon(i == 1 ? Icons.description : Icons.description_outlined),
            label: "Docs",
          ),
          NavigationDestination(
            icon: Icon(i == 2 ? Icons.chat_bubble : Icons.chat_bubble_outline),
            label: "Chat",
          ),
          NavigationDestination(
            icon: Icon(i == 3 ? Icons.filter_none : Icons.filter_none),
            label: "Covering Tab",
          ),
        ],
      ),
    );
  }
}
