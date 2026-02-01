import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/route_guards.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Helper class for authentication-related UI actions
/// Handles logout dialogs, login navigation, and route management
class AuthHelper {
  // Private constructor to prevent instantiation
  AuthHelper._();

  /// Get current route location from GoRouter
  /// Returns the full URI including path and query parameters
  static String _getCurrentLocation(BuildContext context) {
    // Use routeInformationProvider to get the actual URI from browser/navigator
    // This includes query parameters unlike currentConfiguration.uri
    final routeInfo = GoRouter.of(context).routeInformationProvider.value;
    return routeInfo.uri.toString();
  }

  /// Handle login navigation with current route as redirect
  /// Uses RedirectValidator to prevent redirect loops
  static void handleLogin(BuildContext context) {
    final currentLocation = _getCurrentLocation(context);
    // Validate the route to prevent redirect loops with auth screens
    final validRedirect = RedirectValidator.getValidRoute(currentLocation);
    RouterHelper.getLoginRoute(redirectRoute: validRedirect);
  }

  /// Show logout confirmation dialog
  static void showLogoutDialog(BuildContext context) {
    ResponsiveHelper.showDialogOrBottomSheet(
      context,
      Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final locationProvider =  Provider.of<LocationProvider>(context, listen: false);
          return CustomAlertDialogWidget(
            isLoading: authProvider.isLoading,
            title: getTranslated('want_to_sign_out', context),
            icon: Icons.contact_support,
            isSingleButton: authProvider.isLoading,
            leftButtonText: getTranslated('yes', context),
            rightButtonText: getTranslated('no', context),
            onPressLeft: () => _handleLogout(context, authProvider, locationProvider),
          );
        },
      ),
    );
  }

  /// Handle logout process
  static Future<void> _handleLogout(
      BuildContext context,
      AuthProvider authProvider,
      LocationProvider locationProvider,
      ) async {
    try {
      // Clear user data and authentication
      await authProvider.clearSharedData(context);
      locationProvider.onClearAddressList();


      if (!context.mounted) return;

      // Close the dialog
      Navigator.pop(context);

      // Navigate based on platform
      final currentLocation = _getCurrentLocation(context);
      context.pushReplacement(currentLocation);

    } catch (error) {
      // Error handling is done within clearSharedData
      // This catch block ensures proper cleanup even if there's an error
      if (context.mounted) {
        context.pop();
      }
    }
  }

}
