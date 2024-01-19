import 'package:example/features/navigation/router.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: _createTheme(),
      routerConfig: router,
    );
  }

  ThemeData _createTheme() {
    final theme = FlexColorScheme.light(
      useMaterial3: true,
      scheme: FlexScheme.ebonyClay,
    ).toTheme;

    return theme.copyWith(
      cardTheme: CardTheme(
        margin: const EdgeInsets.all(8),
        color: theme.colorScheme.surfaceVariant,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
