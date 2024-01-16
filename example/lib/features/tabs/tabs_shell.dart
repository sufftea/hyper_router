import 'package:example/features/tabs/navigation_tab.dart';
import 'package:flutter/material.dart';
import 'package:fractal_router/fractal_router.dart';

class TabsShell extends StatelessWidget {
  const TabsShell({
    required this.controller,
    required this.child,
    super.key,
  });

  final ShellController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: child,
          ),
          NavigationRail(
            elevation: 8,
            backgroundColor: col.surfaceVariant,
            selectedIndex: controller.tabIndex,
            onDestinationSelected: (index) {
              tabs[index].onClick(context);
            },
            labelType: NavigationRailLabelType.all,
            destinations: tabs.indexed.map((value) {
              final (i, e) = value;

              return NavigationRailDestination(
                icon: i == controller.tabIndex ? e.selectedIcon! : e.icon!,
                label: Text(e.label),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
