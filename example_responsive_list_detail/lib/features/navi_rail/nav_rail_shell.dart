import 'package:flutter/material.dart';
import 'package:responsive_list_detail/features/utils/screen_sizes.dart';
import 'package:tree_router/srs/tree/shell_route.dart';

class NavRailShell extends StatelessWidget {
  const NavRailShell({
    required this.controller,
    required this.child,
    super.key,
  });

  final ShellController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = [
      (Icons.inbox_outlined, Icons.inbox_rounded, "Inbox"),
      (Icons.description_outlined, Icons.description_rounded, "Docs"),
      (Icons.chat_outlined, Icons.chat_rounded, "Chat"),
      (Icons.videocam_outlined, Icons.videocam_rounded, "Video"),
    ];

    final size = MediaQuery.sizeOf(context);
    return switch (size.width) {
      < compactWidth => buildBar(theme, items),
      _ => buildRail(theme, items),
    };
  }

  Scaffold buildBar(ThemeData theme, List<(IconData, IconData, String)> items) {
    return Scaffold(
      floatingActionButton: buildActionButton(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          controller.setTabIndex(value);
        },
        selectedIndex: controller.tabIndex,
        backgroundColor: theme.colorScheme.surfaceVariant,
        surfaceTintColor: Colors.transparent,
        indicatorColor: theme.colorScheme.primaryContainer,
        destinations: items
            .map((e) => NavigationDestination(
                  icon: Icon(e.$1),
                  selectedIcon: Icon(e.$2),
                  label: e.$3,
                ))
            .toList(),
      ),
      body: child,
    );
  }

  Widget buildActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.edit),
    );
  }

  Scaffold buildRail(
    ThemeData theme,
    List<(IconData, IconData, String)> items,
  ) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            onDestinationSelected: (value) {
              controller.setTabIndex(value);
            },
            selectedIndex: controller.tabIndex,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: buildActionButton(),
            ),
            useIndicator: true,
            extended: false,
            labelType: NavigationRailLabelType.all,
            // COLORS
            indicatorColor: theme.colorScheme.primaryContainer,
            backgroundColor: theme.colorScheme.surfaceVariant,
            unselectedLabelTextStyle: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            unselectedIconTheme: IconThemeData(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            selectedLabelTextStyle: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            selectedIconTheme: IconThemeData(
              color: theme.colorScheme.onSecondaryContainer,
            ),
            destinations: items
                .map(
                  (e) => NavigationRailDestination(
                    icon: Icon(e.$1),
                    selectedIcon: Icon(e.$2),
                    label: Text(e.$3),
                  ),
                )
                .toList(),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
