import 'package:dio/dio.dart';
import 'package:resturant_delivery_boy/common/models/track_model.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:resturant_delivery_boy/common/models/api_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  TrackerRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> addTrack({required double lat, required double long}) async {
    try {
      TrackModel trackBody = TrackModel(
        orderId: sharedPreferences!.getInt(AppConstants.orderId).toString(),
        token: sharedPreferences!.getString(AppConstants.token),
        latitude: lat, longitude: long,
      );
      Response response = await dioClient!.post(AppConstants.recordLocationUri, data: trackBody.toJson());
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> setOrderID(int orderID) async {
    return await sharedPreferences!.setInt(AppConstants.orderId, orderID);
  }

}