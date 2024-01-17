import 'package:example/navigation/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fractal_router/fractal_router.dart';

class SomeScreen extends StatelessWidget {
  const SomeScreen({super.key});

  static const routeName1 = RouteName('1');
  static const routeName2 = RouteName('2');
  static const routeName3 = RouteName('3');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepOrange.shade200,
        child: const Center(
          child: Text('something'),
        ),
      ),
    );
  }
}

class LogOutScreen extends StatelessWidget {
  const LogOutScreen({super.key});

  static const routeName = RouteName('logout');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.indigo.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () {
                      ref.watch(authStateProvider.notifier).state = false;
                    },
                    child: const Text('logout'),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PopMeScreen extends StatelessWidget {
  const PopMeScreen({super.key});

  static const routeName = RouteName('pop_screen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple.shade200,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('pop'),
          ),
        ),
      ),
    );
  }
}
