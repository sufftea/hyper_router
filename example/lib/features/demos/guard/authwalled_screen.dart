import 'package:example/features/demos/guard/create_post_screen.dart';
import 'package:example/features/demos/guard/log_out_dialog.dart';
import 'package:flutter/material.dart';
import 'package:snowflake_route/snowflake_route.dart';

class AuthwalledScreen extends StatelessWidget {
  const AuthwalledScreen({super.key});

  static const routeName = RouteName('authwalled-screen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
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
      body: Center(
        child: SizedBox(
          width: 256,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(128),
                  ),
                  child: Image.asset(
                    'assets/guard/secret.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Some secret information',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  context.flake.navigate(CreatePostScreen.routeName);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flutter_dash),
                    SizedBox(width: 8),
                    Text('Open another page'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
