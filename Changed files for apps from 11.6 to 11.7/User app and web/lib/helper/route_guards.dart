import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Route guards for handling authentication and authorization
/// Similar to GetX middleware pattern but implemented for go_router
class RouteGuards {
  
  /// Guard for routes that require authentication
  /// Redirects to login screen with redirect parameter if user is not authenticated
  /// 
  /// Usage:
  /// ```dart
  /// GoRoute(
  ///   path: profileScreen,
  ///   redirect: RouteGuards.requiresAuth,
  ///   builder: (context, state) => const ProfileScreen()
  /// )
  /// ```
  static String? requiresAuth(BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (!authProvider.isLoggedIn()) {
      // Store the intended route for redirect after login
      final intendedRoute = state.uri.toString();
      final encodedRedirect = RedirectValidator.encodeToQueryParam(intendedRoute);
      if (encodedRedirect != null) {
        return '${RouterHelper.loginScreen}?redirect=$encodedRedirect';
      }
      return RouterHelper.loginScreen;
    }
    
    // User is authenticated, allow navigation
    return null;
  }
  
  /// Guard for routes that require auth OR allow guest access
  /// Used for checkout when guest checkout is enabled in config
  /// 
  /// Usage:
  /// ```dart
  /// GoRoute(
  ///   path: checkoutScreen,
  ///   redirect: RouteGuards.requiresAuthOrGuest,
  ///   builder: (context, state) => CheckoutScreen(...)
  /// )
  /// ```
  static String? requiresAuthOrGuest(BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    
    // Check if guest checkout is enabled
    final isGuestCheckoutEnabled = splashProvider.configModel?.isGuestCheckout == true;
    
    if (isGuestCheckoutEnabled) {
      return null; // Allow guest access
    }
    
    // Guest checkout disabled, require authentication
    if (!authProvider.isLoggedIn()) {
      final intendedRoute = state.uri.toString();
      final encodedRedirect = RedirectValidator.encodeToQueryParam(intendedRoute);
      if (encodedRedirect != null) {
        return '${RouterHelper.loginScreen}?redirect=$encodedRedirect';
      }
      return RouterHelper.loginScreen;
    }
    
    return null;
  }
  
  /// Guard for auth screens (login, signup, etc.)
  /// Redirects already-logged-in users to home or their intended destination
  /// This prevents logged-in users from accessing login/signup screens
  /// 
  /// Usage:
  /// ```dart
  /// GoRoute(
  ///   path: loginScreen,
  ///   redirect: RouteGuards.redirectIfAuthenticated,
  ///   builder: (context, state) => LoginScreen(...)
  /// )
  /// ```
  static String? redirectIfAuthenticated(BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isLoggedIn()) {
      // Check if there's a valid redirect route
      final redirectRoute = state.uri.queryParameters['redirect'];
      
      if (redirectRoute != null && RedirectValidator.isValid(redirectRoute)) {
        return redirectRoute; // Go to intended route
      }
      
      return RouterHelper.dashboard; // Go to home
    }
    
    // User not logged in, allow access to auth screen
    return null;
  }
  
  /// Global redirect for maintenance mode
  /// Can be applied to router's global redirect callback
  // static String? handleMaintenance(BuildContext context, GoRouterState state) {
  //   final splashProvider = Provider.of<SplashProvider>(context, listen: false);
  //
  //   if (_isMaintenance(splashProvider.configModel)) {
  //     // Don't redirect if already on maintenance screen
  //     if (state.uri.path != RouterHelper.maintain) {
  //       return RouterHelper.maintain;
  //     }
  //   }
  //
  //   return null;
  // }
  
  /// Helper to check if app is in maintenance mode
  // static bool _isMaintenance(ConfigModel? configModel) {
  //   if (configModel == null) return false;
  //
  //   if (configModel.maintenanceMode?.maintenanceStatus == 1) {
  //     if ((ResponsiveHelper.isWeb() && configModel.maintenanceMode?.selectedMaintenanceSystem?.webApp == 1) ||
  //         (!ResponsiveHelper.isWeb() && configModel.maintenanceMode?.selectedMaintenanceSystem?.customerApp == 1)) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }
}


/// Validator for redirect routes to prevent redirect loops
/// Similar to RedirectRouteValidator in Demandium project
class RedirectValidator {
  // Private constructor to prevent instantiation
  RedirectValidator._();
  
  /// Routes that should never be used as redirect targets
  /// These are authentication flow routes that would create redirect loops
  static const Set<String> _authenticationRoutes = {
    RouterHelper.loginScreen,
    RouterHelper.createAccountScreen,
    RouterHelper.otpVerification,
    RouterHelper.otpRegistration,
    RouterHelper.verify,
    RouterHelper.forgotPassScreen,
    RouterHelper.createNewPassScreen,
  };
  
  /// Check if a route is valid for redirection
  /// Returns false for:
  /// - null or empty routes
  /// - routes containing 'null' string
  /// - authentication routes (to prevent loops)
  static bool isValid(String? route) {
    // Null, empty, or 'null' string are invalid
    if (route == null || route.isEmpty || route == 'null') {
      return false;
    }
    
    // Don't allow redirecting to auth routes (prevent loops)
    final isAuthRoute = _authenticationRoutes.any(route.contains);
    return !isAuthRoute;
  }
  
  /// Get valid route or null
  /// Returns the route if valid, null otherwise
  static String? getValidRoute(String? route) {
    return isValid(route) ? route : null;
  }
  
  /// Encode a redirect route using base64URL encoding
  /// Returns null if the route is invalid
  /// 
  /// This method validates the route before encoding to prevent
  /// redirect loops with authentication routes
  static String? encode(String? route) {
    if (!isValid(route)) return null;
    
    try {
      return base64Url.encode(utf8.encode(route!));
    } catch (e) {
      return null;
    }
  }
  
  /// Decode a base64URL encoded redirect route
  /// Returns null if decoding fails or the decoded route is invalid
  /// 
  /// This method includes error handling for malformed encoded strings
  static String? decode(String? encodedRoute) {
    if (encodedRoute == null || encodedRoute.isEmpty) return null;
    
    try {
      final decoded = utf8.decode(base64Url.decode(encodedRoute));
      return getValidRoute(decoded);
    } catch (e) {
      return null;
    }
  }
  
  /// Complete encoding chain for query parameters
  /// Validates → Base64URL encodes → URI encodes
  /// 
  /// Usage: `?redirect=${RedirectValidator.encodeToQueryParam(route)}`
  static String? encodeToQueryParam(String? route) {
    final encoded = encode(route);
    if (encoded == null) return null;
    
    return Uri.encodeComponent(encoded);
  }
  
  /// Complete decoding chain for query parameters
  /// URI decodes → Base64URL decodes → Validates
  /// 
  /// Usage: `RedirectValidator.decodeFromQueryParam(state.uri.queryParameters['redirect'])`
  static String? decodeFromQueryParam(String? encodedParam) {
    if (encodedParam == null || encodedParam.isEmpty) return null;
    
    try {
      final uriDecoded = Uri.decodeComponent(encodedParam);
      return decode(uriDecoded);
    } catch (e) {
      return null;
    }
  }
}

