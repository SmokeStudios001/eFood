import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class PermissionHandlerProvider extends ChangeNotifier {
  // Private state variables
  bool _isShownLocationWarning = false;
  bool _isShownNotificationWarning = false;
  LocationPermission _locationPermission = LocationPermission.denied;
  bool _isOpenSetting = false;
  bool _isDialogOpen = false;

  // Public getters
  bool get isShownLocationWarning => _isShownLocationWarning;
  bool get isShownNotificationWarning => _isShownNotificationWarning;
  LocationPermission get locationPermission => _locationPermission;
  bool get isOpenSetting => _isOpenSetting;
  bool get isDialogOpen => _isDialogOpen;
  bool get hasAnyWarning => _isShownLocationWarning || _isShownNotificationWarning;

  // Private helper method to update state and notify listeners

  // State management methods
  void setLocationWarningShown(bool value) {
    if (_isShownLocationWarning != value) {
      _isShownLocationWarning = value;
      notifyListeners();
    }
  }

  void setNotificationWarningShown(bool value) {
    if (_isShownNotificationWarning != value) {
      _isShownNotificationWarning = value;
      notifyListeners();
    }
  }

  void setLocationPermission(LocationPermission permission) {
    if (_locationPermission != permission) {
      _locationPermission = permission;
      notifyListeners();
    }
  }

  void setOpenSetting(bool value) {
    if (_isOpenSetting != value) {
      _isOpenSetting = value;
      notifyListeners();
    }
  }

  void setDialogOpen(bool value) {
    if (_isDialogOpen != value) {
      _isDialogOpen = value;
      notifyListeners();
    }
  }


  // Get warning text based on current state
  String getWarningText() {
    if (_isShownNotificationWarning && _isShownLocationWarning) {
      return _locationPermission == LocationPermission.always || _locationPermission == LocationPermission.whileInUse
        ? 'notification_are_disable_and_allow_background_location' 
        : 'notification_and_location_are_disabled_please_allow';
    }
    
    if (_isShownNotificationWarning) {
      return 'notification_are_disabled_please_allow_notification';
    }
    
    if (_isShownLocationWarning) {
      return _locationPermission == LocationPermission.always || _locationPermission == LocationPermission.whileInUse
        ? 'allow_background_location_for_better_accuracy' 
        : 'location_is_off_tap_to_enable';
    }
    
    return '';
  }

}