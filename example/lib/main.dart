import 'package:example/navigation/navigation.dart';
import 'package:flutter/material.dart';

final navKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.from(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(),
        textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: 1.5,
        )
      ).copyWith(),
      routerConfig: router,
    );
  }
}
