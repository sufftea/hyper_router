import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  ColorScheme get col => Theme.of(this).colorScheme;
  double get width => MediaQuery.sizeOf(this).width;
}