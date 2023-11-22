import 'package:flutter/material.dart';
import 'package:tea_router/tea_router.dart';

class ShellTabBarScreen extends StatelessWidget {
  const ShellTabBarScreen({
    required this.child,
    required this.controller,
    super.key,
  });

  final Widget child;
  final ShellController controller;

  @override
  Widget build(BuildContext context) {
    debugPrint('rebuilding shell screen. index: ${controller.tabIndex}');

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          controller.setTabIndex(value);
        },
        currentIndex: controller.tabIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
