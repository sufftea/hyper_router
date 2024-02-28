import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  ColorScheme get col => Theme.of(this).colorScheme;
  ThemeData get theme => Theme.of(this);
  double get width => MediaQuery.sizeOf(this).width;
}
