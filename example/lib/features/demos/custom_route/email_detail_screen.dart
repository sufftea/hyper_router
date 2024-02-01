import 'package:example/features/demos/custom_route/email.dart';
import 'package:example/features/utils/context_x.dart';
import 'package:example/features/utils/screen_sizes.dart';
import 'package:flutter/material.dart';
import 'package:star/star.dart';

class EmailDetailRouteValue extends RouteValue {
  const EmailDetailRouteValue({
    required this.emailId,
    required this.title,
  });
  final String emailId;
  final String title;
}

class EmailDetailScreen extends StatelessWidget {
  EmailDetailScreen({
    required EmailDetailRouteValue value,
    super.key,
  }) : emailId = value.emailId;

  final String emailId;

  @override
  Widget build(BuildContext context) {
    final email = emails[emailId];

    if (email == null)  {
      return const Scaffold(
        body: Center(
          child: Text('An error occurred (ಥ﹏ಥ)'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.star.pop();
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
