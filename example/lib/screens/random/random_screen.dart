import 'package:flutter/material.dart';
import 'package:fractal_router/fractal_router.dart';

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
                // Navigator.of(context).push(route);

                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      width: 200,
                      height: 200,
                      color: Colors.green,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('pop'),
                        ),
                      ),
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
