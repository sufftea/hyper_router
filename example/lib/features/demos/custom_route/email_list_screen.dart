import 'package:example/features/demos/custom_route/email.dart';
import 'package:example/features/demos/custom_route/email_detail_screen.dart';
import 'package:example/features/utils/context_x.dart';
import 'package:flutter/material.dart';
import 'package:hyper_router/hyper_router.dart';

class EmailListScreen extends StatelessWidget {
  const EmailListScreen({super.key});

  static const routeName = RouteName('emails');

  @override
  Widget build(BuildContext context) {
    final emailList = emails.values.toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.hyper.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.builder(
        itemCount: emailList.length,
        itemBuilder: (context, index) {
          return EmailEntryWidget(
            email: emailList[index],
          );
        },
      ),
    );
  }
}

class EmailEntryWidget extends StatelessWidget {
  const EmailEntryWidget({
    required this.email,
    super.key,
  });

  final Email email;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.hyper.navigate(EmailDetailRouteValue(
          emailId: email.id,
          title: email.title,
        ));
      },
      splashFactory: InkSparkle.splashFactory,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person_4)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        email.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        '10 minutes ago',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.outlined(
                  onPressed: () {},
                  color: context.col.onSurfaceVariant,
                  icon: const Icon(Icons.star_outline),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              email.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              email.content,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
