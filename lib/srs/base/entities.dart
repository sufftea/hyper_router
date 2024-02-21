import 'package:flutter/material.dart';
import 'package:hyper_router/srs/route/hyper_route.dart';

class RedirectState {
  RedirectState({required this.stack});

  final RouteNode stack;
}

class OnExceptionState {
  OnExceptionState({
    required this.routeInformation,
    required this.exception,
  });

  final RouteInformation routeInformation;
  final Exception exception;
}
