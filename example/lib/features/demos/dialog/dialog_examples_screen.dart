import 'package:example/features/demos/dialog/dialog_screen.dart';
import 'package:example/features/demos/dialog/text_dialog.dart';
import 'package:example/features/widgets/limit_width.dart';
import 'package:flutter/material.dart';
import 'package:snowflake_route/snowflake_route.dart';

class DialogExamplesScreen extends StatelessWidget {
  const DialogExamplesScreen({super.key});

  static const routeName = RouteName('dialog-examples');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LimitWidth(
        maxWidth: 256,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (context) => const TextDialog(),
                );

                if (result is String?) {
                  debugPrint('Result: $result');
                } else {
                  debugPrint('Something went wrong. Result: $result');
                }
              },
              child: const Text('Open a dialog'),
            ),
            OutlinedButton(
              onPressed: () async {
                final result = await context.flake.push(DialogScreen.routeName);

                if (result is String?) {
                  debugPrint('Result: $result');
                } else {
                  debugPrint('Something went wrong. Result: $result');
                }
              },
              child: const Text('Open a page'),
            ),
          ],
        ),
      ),
    );
  }
}
