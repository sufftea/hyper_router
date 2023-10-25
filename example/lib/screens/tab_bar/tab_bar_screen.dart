import 'package:flutter/material.dart';
import 'package:flutter_stack_router/shell_route.dart';
import 'package:flutter_stack_router/stack_router.dart';

class TabBarRouteData {
  const TabBarRouteData(this.controller);

  final TabStackRouterController controller;
}

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({
    required this.data,
    super.key,
  });

  final TabBarRouteData data;

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.data.controller;

    return Scaffold(
      body: NestedNavigator(controller: controller),
      bottomNavigationBar: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return BottomNavigationBar(
            onTap: (value) {
              controller.tab = value;
            },
            currentIndex: controller.tab,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'profile'),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'settings'),
            ],
          );
        },
      ),
    );
  }
}
