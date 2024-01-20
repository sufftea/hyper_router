import 'package:example/features/tabs/navigation_tab.dart';
import 'package:example/features/utils/context_x.dart';
import 'package:example/features/utils/screen_sizes.dart';
import 'package:flutter/material.dart';
import 'package:snowflake_route/srs/route/shell_route.dart';

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
    return switch (context.width) {
      < mediumWidth => _ShellWithAppBar(
          controller: controller,
          child: child,
        ),
      _ => _ShellWithNavRail(
          controller: controller,
          child: child,
        ),
    };
  }
}

class _ShellWithNavRail extends StatelessWidget {
  const _ShellWithNavRail({
    required this.child,
    required this.controller,
  });

  final Widget child;
  final ShellController controller;

  @override
  Widget build(BuildContext context) {
    final col = context.col;

    return Scaffold(
      body: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: child,
          ),
          NavigationRail(
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

class _ShellWithAppBar extends StatelessWidget {
  _ShellWithAppBar({
    required this.controller,
    required this.child,
  });

  final ShellController controller;
  final Widget child;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: ,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          );
        }),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: tabs.indexed.map((value) {
              final (_, e) = value;

              return Builder(builder: (context) {
                return TextButton(
                  onPressed: () {
                    e.onClick(context);
                    Scaffold.of(context).closeDrawer();
                  },
                  child: Row(
                    children: [
                      e.icon!,
                      const SizedBox(width: 16),
                      Text(e.label),
                    ],
                  ),
                );
              });
            }).toList(),
          ),
        ),
      ),
      body: child,
    );
  }
}
