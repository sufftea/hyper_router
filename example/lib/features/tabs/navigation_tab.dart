// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:example/features/guide/guide_screen.dart';
import 'package:example/features/home/home_screen.dart';
import 'package:example/features/internals/internal_screen.dart';
import 'package:flutter/material.dart';
import 'package:snowflake_route/snowflake_route.dart';

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

final tabs = [
  NavigationTab(
    icon: const Icon(Icons.local_florist_outlined),
    selectedIcon: const Icon(Icons.local_florist),
    label: "Home",
    onClick: (BuildContext context) {
      context.flake.navigate(HomeScreen.routeName);
    },
  ),
  NavigationTab(
    icon: const Icon(Icons.developer_mode),
    selectedIcon: const Icon(Icons.developer_mode),
    label: "Guide",
    onClick: (BuildContext context) {
      context.flake.navigate(GuideScreen.routeName);
    },
  ),
  NavigationTab(
    icon: const Icon(Icons.settings_applications_outlined),
    selectedIcon: const Icon(Icons.settings_applications),
    label: "Insides",
    onClick: (BuildContext context) {
      context.flake.navigate(InsideScreen.routeName);
    },
  ),
];
