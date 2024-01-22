import 'package:example/features/utils/context_x.dart';
import 'package:example/features/utils/material_match.dart';
import 'package:flutter/material.dart';
import 'package:snowflake_route/snowflake_route.dart';

class DialogScreen extends StatefulWidget {
  const DialogScreen({super.key});

  static const routeName = RouteName('dialog-screen');

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter text',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(hintText: 'text'),
              controller: textController,
            ),
            // const SizedBox(height: 16),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    context.flake.pop();
                  },
                  style: ButtonStyle(
                    textStyle: materialMatch(
                      all: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    foregroundColor: materialMatch(all: context.col.error),
                  ),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context.flake.pop(textController.text);

                    // This would also work:
                    // Navigator.of(context).pop(textController.text);
                  },
                  style: ButtonStyle(
                    textStyle: materialMatch(
                      all: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
