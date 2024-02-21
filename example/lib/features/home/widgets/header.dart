import 'dart:ui';

import 'package:example/features/utils/context_x.dart';
import 'package:example/features/utils/screen_sizes.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/home/header.jpeg',
              color: context.col.primaryContainer.withOpacity(0.5),
              colorBlendMode: BlendMode.modulate,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'HYPER_ROUTER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: switch (context.width) {
                        > mediumWidth => 92,
                        > compactWidth => 64,
                        _ => 48,
                      },
                      color: context.col.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
