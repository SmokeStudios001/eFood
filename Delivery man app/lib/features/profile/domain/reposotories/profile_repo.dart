import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:resturant_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:resturant_delivery_boy/common/models/api_response_model.dart';
import 'package:resturant_delivery_boy/features/profile/domain/models/userinfo_model.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getUserInfo() async {
    try {
      final response = await dioClient!.get('${AppConstants.profileUri}${sharedPreferences!.getString(AppConstants.token)}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> updateProfile(UserInfoModel userInfoModel, String password, File? file, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updateProfileUri}'));
    // request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null) {
      request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put', 'f_name': userInfoModel.fName!, 'l_name': userInfoModel.lName!, 'phone': userInfoModel.phone!, 'token': token, 'password': password
      });
    request.fields.addAll(fields);

    http.StreamedResponse response = await request.send();
    return response;
  }



}
