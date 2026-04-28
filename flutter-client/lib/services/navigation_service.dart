import 'package:flutter/material.dart';

class NavigationService extends ChangeNotifier {
  static final NavigationService instance = NavigationService._internal();

  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final List<String> _backStack = [];
  final List<String> _forwardStack = [];

  bool get canGoBack => _backStack.length > 1; // Current route + at least 1 previous
  bool get canGoForward => _forwardStack.isNotEmpty;

  bool _isForwarding = false;
  bool _isPopping = false;

  void goBack() {
    if (canGoBack) {
      _isPopping = true;
      navigatorKey.currentState?.pop();
      _isPopping = false;
    }
  }

  void goForward() {
    if (canGoForward) {
      final route = _forwardStack.removeLast();
      _isForwarding = true;
      navigatorKey.currentState?.pushNamed(route);
      _isForwarding = false;
      notifyListeners();
    }
  }

  void recordPush(String? routeName) {
    if (routeName != null) {
      _backStack.add(routeName);
      if (!_isForwarding) {
        _forwardStack.clear();
      }
      // Delaying notifyListeners to avoid build phase conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void recordPop(String? routeName) {
    if (routeName != null && _backStack.isNotEmpty) {
      _backStack.removeLast();
      _forwardStack.add(routeName);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void recordReplace(String? newRouteName, String? oldRouteName) {
    if (newRouteName != null && _backStack.isNotEmpty) {
      _backStack.removeLast();
      _backStack.add(newRouteName);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}

class BrowserNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    NavigationService.instance.recordPush(route.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    NavigationService.instance.recordPop(route.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    NavigationService.instance.recordReplace(newRoute?.settings.name, oldRoute?.settings.name);
  }
}
