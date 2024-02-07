import 'package:example/features/demos/guard/log_out_dialog.dart';
import 'package:flutter/material.dart';
import 'package:star/star.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  static const routeName = RouteName('create-post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const LogOutDialog();
                },
              );
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 32),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Some other screen',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
