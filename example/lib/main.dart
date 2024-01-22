import 'package:example/features/demos/guard/state/auth_cubit.dart';
import 'package:example/features/navigation/router.dart';
import 'package:example/features/utils/material_match.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: MaterialApp.router(
        theme: _createTheme(),
        routerConfig: router,
      ),
    );
  }

  ThemeData _createTheme() {
    final theme = FlexColorScheme.light(
      useMaterial3: true,
      scheme: FlexScheme.aquaBlue,
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
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 32),
        hoverColor: theme.colorScheme.tertiaryContainer,
        filled: true,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: materialMatch(
            all: const TextStyle(
              fontSize: 16,
            ),
          ),
          padding: materialMatch(all: const EdgeInsets.all(24)),
          splashFactory: InkSparkle.splashFactory,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: materialMatch(
            all: const TextStyle(
              fontSize: 16,
            ),
          ),
          padding: materialMatch(all: const EdgeInsets.all(24)),
          splashFactory: InkSparkle.splashFactory,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: materialMatch(
            all: const TextStyle(
              fontSize: 16,
            ),
          ),
          padding: materialMatch(all: const EdgeInsets.all(24)),
          splashFactory: InkSparkle.splashFactory,
        ),
      ),
      dialogTheme: DialogTheme(
        actionsPadding: const EdgeInsets.all(32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}
