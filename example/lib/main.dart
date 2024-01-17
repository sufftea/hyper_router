import 'package:example/navigation/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        theme: ThemeData.from(
          useMaterial3: true,
          colorScheme: const ColorScheme.light(),
          textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: 1.5,
              ),
        ).copyWith(),
        routerConfig: router,
      ),
    );
  }
}
