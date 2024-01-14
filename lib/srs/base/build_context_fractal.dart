import 'package:flutter/material.dart';
import 'package:fractal_router/fractal_router.dart';

extension BuildContextFractal on BuildContext {
  RootFractalController get frouter => FractalRouter.of(this);
}
