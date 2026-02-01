import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/providers/data_sync_provider.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/splash/domain/reposotories/splash_repo.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/features/home/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class BranchProvider extends DataSyncProvider {
  final SplashRepo? splashRepo;

  BranchProvider({required this.splashRepo});

  int? _selectedBranchId;

  int? get selectedBranchId => _selectedBranchId;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  int _branchTabIndex = 0;

  int get branchTabIndex => _branchTabIndex;
  bool _showSearchBox = false;

  bool get showSearchBox => _showSearchBox;

  List<BranchValue>? _branchValueList;

  List<BranchValue>? get branchValueList => _branchValueList;


  void updateSearchBox(bool status) {
    _showSearchBox = status;
    notifyListeners();
  }

  void updateTabIndex(int index, {bool isUpdate = true}) {
    _branchTabIndex = index;
    if (isUpdate) {
      notifyListeners();
    }
  }


  void updateBranchId(int? value, {bool isUpdate = true}) {
    _selectedBranchId = value;
    if (isUpdate) {
      notifyListeners();
    }
  }

  int getBranchId() => splashRepo?.getBranchId() ?? -1;

  Future<void> setBranch(int id, SplashProvider splashProvider) async {
    await splashRepo?.setBranchId(id);
    await splashProvider.getDeliveryInfo(id);
    await HomeScreen.loadData(true);
    notifyListeners();
  }

  Branches? getBranch({int? id}) {
    int branchId = id ?? getBranchId();
    Branches? branch;
    ConfigModel config = Provider
        .of<SplashProvider>(Get.context!, listen: false)
        .configModel!;
    if (config.branches != null && config.branches!.isNotEmpty) {
      branch = config.branches!.firstWhere((branch) => branch!.id == branchId,
          orElse: () => null);
      if (branch == null) {
        splashRepo!.setBranchId(-1);
      }
    }
    return branch;
  }


  Future<List<BranchValue>> branchSort(LatLng? currentLatLng) async {
    _isLoading = true;
    notifyListeners();

    final List<Branches?> branches = Provider
        .of<SplashProvider>(Get.context!, listen: false)
        .configModel!
        .branches!;

    List<BranchValue> branchValueList;

    if (currentLatLng != null && branches.isNotEmpty) {
      // Run the heavy computation in a separate isolate
      branchValueList = await compute(
        _calculateBranchDistances,
        _BranchSortData(branches: branches, currentLocation: currentLatLng),
      );
    } else {
      // If no location, just create the list without sorting
      branchValueList = branches
          .map((branch) => BranchValue(branch, -1))
          .toList();
    }

    _isLoading = false;
    notifyListeners();

    return branchValueList;
  }

  /// Static method to run in isolate - calculates distances and sorts branches
  static List<BranchValue> _calculateBranchDistances(_BranchSortData data) {
    final List<BranchValue> branchValueList = [];

    for (var branch in data.branches) {
      final double distance = Geolocator.distanceBetween(
        branch!.latitude!,
        branch.longitude!,
        data.currentLocation.latitude,
        data.currentLocation.longitude,
      ) / 1000;

      branchValueList.add(BranchValue(branch, distance));
    }

    // Sort by distance
    branchValueList.sort((a, b) => a.distance.compareTo(b.distance));

    return branchValueList;
  }





  Future<List<BranchValue>> getBranchValueList(BuildContext context) async {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    LatLng? currentLocationLatLng;

    await locationProvider.getCurrentLatLong().then((latLong) async {
      if (latLong != null) {
        currentLocationLatLng = latLong;
      }
      _branchValueList = await branchSort(currentLocationLatLng);
    });

    notifyListeners();

    return _branchValueList ?? [];
  }

}

/// Data class for passing to isolate
class _BranchSortData {
  final List<Branches?> branches;
  final LatLng currentLocation;

  _BranchSortData({required this.branches, required this.currentLocation});
}