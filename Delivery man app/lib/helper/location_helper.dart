import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/providers/permission_handler_provider.dart';
import 'package:resturant_delivery_boy/features/home/widgets/location_permission_widget.dart';
import 'package:resturant_delivery_boy/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart' as loc;


class LocationHelper{
  static List<BuildContext> openDialogs = []; // List to track open dialogs

  static Future<void> checkPermission(BuildContext context, {Function? callBack}) async {
    final loc.Location location = loc.Location();

    if(! await location.serviceEnabled()) {
      await location.requestService();
    }
    LocationPermission permission = await Geolocator.checkPermission();


    if(permission == LocationPermission.denied) {
      final beforeRequest = DateTime.now();
      permission = await Geolocator.requestPermission();
      Geolocator.isLocationServiceEnabled();

      final difference =  DateTime.now().difference(beforeRequest);

      debugPrint('-------dif-----(${difference.inMilliseconds})');

      if (difference.inMilliseconds < 800) {
        permission = LocationPermission.deniedForever; // Assume permanently denied

      }else {
        if(permission == LocationPermission.deniedForever) {
          permission = LocationPermission.denied;
        }
      }
    }

    if(permission == LocationPermission.deniedForever) {

      onLocationShowDialog(Get.context!, dialog: LocationPermissionWidget(onPressed: () async {
        Navigator.pop(Get.context!);
        final permissionProvider = Provider.of<PermissionHandlerProvider>(Get.context!, listen: false);
        permissionProvider.setOpenSetting(true);
        await Geolocator.openAppSettings();

      }));

    }else if(callBack != null ){
      final LocationPermission permission = await Geolocator.checkPermission();

      if(permission != LocationPermission.denied && permission != LocationPermission.deniedForever && await Geolocator.isLocationServiceEnabled()) {
        callBack();
      }
    }
  }

  static void onLocationShowDialog(BuildContext context, {required Widget dialog}) async {
    _dismissAllDialogs();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // Add the dialog's context to the list of open dialogs
        openDialogs.add(context);

        return dialog;
      },
    );
  }


  static Future<void> openMap({required double destinationLatitude, required double destinationLongitude, double? userLatitude, double? userLongitude}) async {
    String googleUrl;
    if (userLatitude != null && userLongitude != null) {
      googleUrl =
      'https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude&destination=$destinationLatitude,$destinationLongitude&mode=d';
    } else {
      googleUrl = 'https://www.google.com/maps/search/?api=1&query=$destinationLatitude,$destinationLongitude';
    }
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }

  static void _dismissAllDialogs() {
    // Dismiss all open dialogs
    for (var dialogContext in openDialogs) {
      if(dialogContext.mounted) {
        if (Navigator.canPop(dialogContext)) {
          Navigator.pop(dialogContext); // Dismiss the dialog
        }
      }

    }

    // Clear the list of open dialogs
    openDialogs.clear();
  }

}