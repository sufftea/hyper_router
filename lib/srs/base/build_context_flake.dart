import 'package:flutter/material.dart';
import 'package:snowflake_route/snowflake_route.dart';
import 'package:snowflake_route/srs/base/flake_controller.dart';

extension BuildContextFlake on BuildContext {
  FlakeController get flake => Snowflake.of(this);
}
