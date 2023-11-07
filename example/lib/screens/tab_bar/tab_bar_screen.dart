import 'package:example/screens/home/home_screen.dart';
import 'package:example/screens/post/post_screen.dart';
import 'package:example/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stack_router/stack_router.dart';

class TabBarRouteData {
  const TabBarRouteData();
}

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  final controller = TabStackRouterController(
    initialTab: 1,
    tabs: [
      RouteStack([const ProfileRouteData()]),
      RouteStack([const HomeRouteData()]),
      RouteStack([const PostRouteData('settings screen')]),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedStackRouter(controller: controller),
      bottomNavigationBar: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return BottomNavigationBar(
            onTap: (value) {
              if (controller.tab == value) {
                controller.stack = controller.stack.root();
              } else {
                controller.tab = value;
              }
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
