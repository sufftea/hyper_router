import 'dart:async';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_list_detail/features/navigation/router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        theme: FlexThemeData.light(
          useMaterial3: true,
          colors: FlexColor.schemes[FlexScheme.indigoM3]!.light,
        ).copyWith(
          hoverColor: Colors.lightBlue.shade50,
          splashColor: Colors.lightBlue.shade100,
        ),
      ),
    );
  }
}
