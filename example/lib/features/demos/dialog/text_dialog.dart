import 'package:example/features/utils/material_match.dart';
import 'package:flutter/material.dart';
import 'package:hyper_router/hyper_router.dart';

class TextDialog extends StatefulWidget {
  const TextDialog({super.key});

  static const routeName = RouteName('text-dialog');

  @override
  State<TextDialog> createState() => _TextDialogState();
}

class _TextDialogState extends State<TextDialog> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 256),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      context.hyper.pop(textController.text);

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
      ),
    );
  }
}
