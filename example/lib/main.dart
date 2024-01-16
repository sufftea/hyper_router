<<<<<<< HEAD
import 'package:example/navigation/router.dart';
=======
import 'package:example/features/navigation/router.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
>>>>>>> 418587c (Tabs shell; Initial home screen)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final navKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (context) => ValueNotifier(true),
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
=======
    return MaterialApp.router(
      theme: _createTheme(),
      routerConfig: router,
>>>>>>> 418587c (Tabs shell; Initial home screen)
    );
  }

  ThemeData _createTheme() {
    return FlexColorScheme.light(
      useMaterial3: true,
      scheme: FlexScheme.ebonyClay,
    ).toTheme;
  }
}
