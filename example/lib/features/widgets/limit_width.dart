import 'package:example/features/utils/screen_sizes.dart';
import 'package:flutter/material.dart';

class LimitWidth extends StatelessWidget {
  const LimitWidth({
    required this.child,
    this.maxWidth = expandedWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
