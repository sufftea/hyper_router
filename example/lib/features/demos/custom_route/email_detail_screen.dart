import 'package:example/features/demos/custom_route/email.dart';
import 'package:example/features/demos/custom_route/responsive_route.dart';
import 'package:example/features/utils/context_x.dart';
import 'package:example/features/utils/screen_sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snowflake_route/snowflake_route.dart';

class EmailDetailRouteValue extends RouteValue {
  const EmailDetailRouteValue(this.email);
  final Email email;
}

class EmailDetailScreen extends StatelessWidget {
  const EmailDetailScreen({
    required this.email,
    super.key,
  });

  final Email email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.flake.pop();
          },
          icon: switch (context.width) {
            < mediumWidth => const Icon(Icons.arrow_back),
            _ => const Icon(Icons.close),
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.person_4),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email.userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SizedBox(height: 4),
                      const Text(
                        '15 minutes ago',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton.outlined(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_outline),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                email.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                email.content,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
