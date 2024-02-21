import 'package:example/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hyper_router/srs/url/url_parser.dart';
import 'package:hyper_router/hyper_router.dart';

class ErrorRouteValue extends RouteValue {
  ErrorRouteValue(this.routeInformation);

  final RouteInformation routeInformation;
}

class ErrorSegmentParser extends UrlSegmentParser<ErrorRouteValue> {
  @override
  ErrorRouteValue? decodeSegment(SegmentData segment) {
    return null;
  }

  @override
  SegmentData encodeSegment(ErrorRouteValue value) {
    return SegmentData(name: 'error');
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    required this.value,
    super.key,
  });

  final ErrorRouteValue value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              "Couldn't parse URL: ${value.routeInformation.uri}",
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: FilledButton(
              onPressed: () {
                context.hyper.navigate(HomeScreen.routeName);
              },
              child: const Text('Go home'),
            ),
          ),
        ],
      ),
    );
  }
}
