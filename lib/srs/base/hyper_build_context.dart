import 'package:flutter/material.dart';
import 'package:hyper_router/hyper_router.dart';
import 'package:hyper_router/srs/base/hyper_controller.dart';

extension HyperBuildContext on BuildContext {
  HyperController get hyper => HyperRouter.of(this);
}
