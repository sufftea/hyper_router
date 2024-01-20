import 'package:flutter/material.dart';

class NavigationTab {
  NavigationTab({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onClick,
    this.children = const [],
  });

  final Widget? icon;
  final Widget? selectedIcon;
  final String label;
  final Function(BuildContext context) onClick;
  final List<NavigationTab> children;

  NavigationTab copyWith({
    Widget? icon,
    Widget? selectedIcon,
    String? label,
    Function(BuildContext context)? onClick,
    List<NavigationTab>? children,
  }) {
    return NavigationTab(
      icon: icon ?? this.icon,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      label: label ?? this.label,
      onClick: onClick ?? this.onClick,
      children: children ?? this.children,
    );
  }
}
