import 'package:flutter/material.dart';

extension ThemeX on BuildContext {
  ColorScheme get col => Theme.of(this).colorScheme;
}