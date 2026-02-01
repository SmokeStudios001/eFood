import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:resturant_delivery_boy/common/models/api_response_model.dart';
import 'package:resturant_delivery_boy/common/models/response_model.dart';
import 'package:resturant_delivery_boy/features/profile/domain/models/userinfo_model.dart';
import 'package:resturant_delivery_boy/features/profile/domain/reposotories/profile_repo.dart';
import 'package:resturant_delivery_boy/helper/api_checker_helper.dart';
import 'package:resturant_delivery_boy/helper/file_validation_helper.dart';
import 'package:resturant_delivery_boy/main.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo? profileRepo;

  ProfileProvider({required this.profileRepo});

  UserInfoModel? _userInfoModel;
  bool _isLoading = false;
  File? file;
  XFile? data;
  final picker = ImagePicker();


  UserInfoModel? get userInfoModel => _userInfoModel;
  bool get isLoading => _isLoading;


  void choose() async {
    final pickedFile = await FileValidationHelper.validateAndPickImage(
      context: Get.context!,
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 500,
    );
    if (pickedFile != null) {
      file = File(pickedFile.path);
    }
    notifyListeners();
  }



  Future<void> getUserInfo(BuildContext context) async {
    _isLoading = true;
    ApiResponseModel apiResponse = await profileRepo!.getUserInfo();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }


  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String password, File? file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response = await profileRepo!.updateProfile(updateUserModel, password, file, token);

    Map map = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      String? message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(true, message);
    } else {
      responseModel = ResponseModel(false, '${map['errors'][0]['message']}');
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

}
