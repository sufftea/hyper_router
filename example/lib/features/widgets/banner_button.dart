import 'package:example/features/utils/context_x.dart';
import 'package:example/features/utils/material_match.dart';
import 'package:flutter/material.dart';

class BannerButton extends StatelessWidget {
  const BannerButton({
    required this.onPressed,
    required this.title,
    required this.image,
    this.caption,
    super.key,
  });

  final String title;
  final Widget? caption;
  final String image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FilledButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll(EdgeInsets.zero),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
          backgroundColor: materialMatch(
            all: context.col.surfaceVariant,
            hovered: context.col.secondaryContainer,
          ),
          foregroundColor: materialMatch(all: context.col.onSurfaceVariant),
          splashFactory: InkSparkle.splashFactory,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (caption case final caption?) caption,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
