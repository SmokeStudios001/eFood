// ignore_for_file: empty_catches

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resturant_delivery_boy/common/models/track_model.dart';
import 'package:resturant_delivery_boy/common/models/api_response_model.dart';
import 'package:resturant_delivery_boy/common/reposotories/tracker_repo.dart';

class TrackerProvider extends ChangeNotifier {
  final TrackerRepo? trackerRepo;
  TrackerProvider({required this.trackerRepo});

  final List<TrackModel> _trackList = [];
  final int _selectedTrackIndex = 0;
  final bool _isBlockButton = false;
  final bool _canDismiss = true;
  bool _startTrack = false;
  Timer? _timer;

  List<TrackModel> get trackList => _trackList;
  int get selectedTrackIndex => _selectedTrackIndex;
  bool get isBlockButton => _isBlockButton;
  bool get canDismiss => _canDismiss;
  bool get startTrack => _startTrack;

  Position? _lastPosition;
  StreamSubscription<Position>? _positionStream;
  bool get isPositionStreamActive => _positionStream != null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _currentId;
  int? get currentId => _currentId;

  void stopLocationService() {
    _startTrack = false;
    if(_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    if (kDebugMode) {
      print("------------------------- Location service Stopped ----------------------- ");
    }
    notifyListeners();
  }


  void startListenCurrentLocation() {
    if (_positionStream == null) {

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          distanceFilter: 10,
          accuracy: LocationAccuracy.high,
        ),
      ).listen((Position position) async {

        if (_lastPosition != null) {
          double distance = Geolocator.distanceBetween(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
            position.latitude,
            position.longitude,
          );

          if (distance > 10) {

            ApiResponseModel apiResponse = await trackerRepo!.addTrack(lat: position.latitude, long: position.longitude);

            if (kDebugMode) {
              print("Location update status on sever ---- ${apiResponse.response?.statusCode}");
            }

          }
        }
        _lastPosition = position; // Update last known position
      });

      if (kDebugMode) {
        print("Location tracking started.");
      }
    }
  }

  Future<Position> getUserCurrentLocation() async {
    _isLoading = true;
    notifyListeners();

    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    _isLoading = false;
    notifyListeners();

    return position;
  }

  void onChangeCurrentId(int index)  {
    _currentId = index;
    notifyListeners();
  }

  void stopListening() {
    _positionStream?.cancel();
    _positionStream = null;
    if (kDebugMode) {
      print("Location tracking stopped.");
    }
  }


}
