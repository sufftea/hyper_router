import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/destination/shell_destination.dart';

class ShellTabBarScreen extends StatelessWidget {
  const ShellTabBarScreen({
    required this.child,
    required this.tabController,
    super.key,
  });

  final Widget child;
  final ShellRouterController tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          tabController.tab = value;
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
