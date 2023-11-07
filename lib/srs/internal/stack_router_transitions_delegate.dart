import 'package:flutter/material.dart';

// TODO: probably don't need this at all
class StackRouterTransitionsDelegate extends TransitionDelegate {
  @override
  Iterable<RouteTransitionRecord> resolve({
    required List<RouteTransitionRecord> newPageRouteHistory,
    required Map<RouteTransitionRecord?, RouteTransitionRecord>
        locationToExitingPageRoute,
    required Map<RouteTransitionRecord?, List<RouteTransitionRecord>>
        pageRouteToPagelessRoutes,
  }) {
    debugPrint('newPageRouteHistory: $newPageRouteHistory');
    debugPrint('locationToExitingPageRoute: $locationToExitingPageRoute');
    debugPrint('pageRouteToPagelessRoutes: $pageRouteToPagelessRoutes');
    
    return [];
  }
}
