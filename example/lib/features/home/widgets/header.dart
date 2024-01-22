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
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Snowflake',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // color: Color.fromARGB(255, 9, 18, 56),
                      fontSize: switch (context.width) {
                        > mediumWidth => 96,
                        > compactWidth => 64,
                        _ => 48,
                      },
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Theme(
                  data: context.theme.copyWith(
                    cardTheme: CardTheme(
                      elevation: 0,
                      color: context.col.inverseSurface,
                    ),
                    textTheme: context.theme.textTheme.merge(TextTheme(
                      bodyMedium: TextStyle(
                          fontSize: 24, color: context.col.onInverseSurface),
                    )),
                  ),
                  child: const Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Card(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('Declarative'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('Value-based'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('No codegen'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('Extensible'),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('No boilerplate'),
                        ),
                      ),
                    ],
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
