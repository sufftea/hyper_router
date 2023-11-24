import 'package:flutter/material.dart';
import 'package:tree_router/tree_router.dart';

class RandomScreen extends StatelessWidget {
  const RandomScreen({super.key});

  static const routeValue = RouteName('random');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green.shade200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      width: 200,
                      height: 200,
                      color: Colors.green,
                    );
                  },
                );
              },
              child: const Text('test...'),
            ),
          ],
        ),
      ),
    );
  }
}
