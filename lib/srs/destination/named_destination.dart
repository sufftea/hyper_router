import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/destination/value_destination.dart';
import 'package:flutter_stack_router/srs/value/destination_value.dart';

class NamedDestination extends ValueDestination<DestinationName> {
  NamedDestination({
    required Widget Function(BuildContext context) screenBuilder,
    required this.nameKey,
    super.pageBuilder,
    super.children,
  }) : super(
          defaultValue: nameKey,
          screenBuilder: (context, _) => screenBuilder(context),
        );

  final DestinationName nameKey;

  @override
  Object get key => nameKey.key;
}
