
import 'package:flutter/material.dart';
import 'package:flutter_stack_router/srs/route_stack.dart';

abstract class StackRouterControllerBase extends ChangeNotifier {
  RouteStack get stack;
  set stack(RouteStack value);
}

class StackRouterController extends StackRouterControllerBase {
  StackRouterController({
    required RouteStack initialStack,
  }) : _stack = initialStack;

  RouteStack _stack;

  @override
  RouteStack get stack => _stack;

  @override
  set stack(RouteStack value) {
    _stack = value;
    notifyListeners();
  }
}

class TabStackRouterController extends StackRouterControllerBase {
  TabStackRouterController({
    required List<RouteStack> tabs,
    required initialTab,
  })  : _currentTab = initialTab,
        _tabs = tabs;

  int _currentTab;
  final List<RouteStack> _tabs;

  int get tab => _currentTab;
  set tab(int index) {
    _currentTab = index;
    notifyListeners();
  }

  @override
  RouteStack get stack => _tabs[_currentTab];
  @override
  set stack(RouteStack value) {
    _tabs[_currentTab] = value;
    notifyListeners();
  }
}
