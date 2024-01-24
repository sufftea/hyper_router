import 'package:flutter/material.dart';
import 'package:star/star.dart';
import 'package:star/srs/base/star_controller.dart';

extension StarBuildContext on BuildContext {
  StarController get star => Star.of(this);
}
