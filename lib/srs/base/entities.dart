import 'package:flutter/material.dart';
import 'package:star/srs/route/star_route.dart';

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
