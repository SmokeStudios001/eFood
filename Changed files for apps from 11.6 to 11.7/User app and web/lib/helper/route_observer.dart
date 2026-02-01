import 'package:flutter/material.dart';

/// Custom NavigatorObserver to log all route changes for debugging
class RouteDebugObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    debugPrint('══════════════════════════════════════════════');
    debugPrint('🔵 ROUTE PUSHED');
    debugPrint('  From: ${_getRouteName(previousRoute)}');
    debugPrint('  To:   ${_getRouteName(route)}');
    debugPrint('══════════════════════════════════════════════');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    debugPrint('══════════════════════════════════════════════');
    debugPrint('🔴 ROUTE POPPED');
    debugPrint('  From: ${_getRouteName(route)}');
    debugPrint('  To:   ${_getRouteName(previousRoute)}');
    debugPrint('══════════════════════════════════════════════');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint('══════════════════════════════════════════════');
    debugPrint('🟡 ROUTE REPLACED');
    debugPrint('  Old: ${_getRouteName(oldRoute)}');
    debugPrint('  New: ${_getRouteName(newRoute)}');
    debugPrint('══════════════════════════════════════════════');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    debugPrint('══════════════════════════════════════════════');
    debugPrint('🟠 ROUTE REMOVED');
    debugPrint('  Removed: ${_getRouteName(route)}');
    debugPrint('  Previous: ${_getRouteName(previousRoute)}');
    debugPrint('══════════════════════════════════════════════');
  }

  /// Extract route name from Route object
  String _getRouteName(Route<dynamic>? route) {
    if (route == null) return 'null';
    
    // Try to get the route settings name first
    if (route.settings.name != null && route.settings.name!.isNotEmpty) {
      return route.settings.name!;
    }
    
    // For other routes, return the route type
    return route.runtimeType.toString();
  }
}
