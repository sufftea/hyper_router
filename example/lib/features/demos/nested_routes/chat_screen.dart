import 'package:example/features/widgets/limit_width.dart';
import 'package:flutter/material.dart';
import 'package:star/star.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static const routeName = RouteName('chat');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.star.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: LimitWidth(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(64),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset('assets/nested/chat.jpeg'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chat',
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
