import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/models/api_response_model.dart';
import 'package:resturant_delivery_boy/common/models/error_response_model.dart';
import 'package:resturant_delivery_boy/helper/show_custom_snackbar_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/main.dart';
import 'package:resturant_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:resturant_delivery_boy/features/auth/screens/login_screen.dart';

class ApiCheckerHelper {
  static void checkApi(ApiResponseModel apiResponse, {EdgeInsetsGeometry? tosterMargin}) {
    ErrorResponseModel error = getError(apiResponse);

    if((error.errors![0].code == '401' || error.errors![0].code == 'auth-001')) {
      Provider.of<SplashProvider>(Get.context!, listen: false).removeSharedData();
      Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
    }else {
      showCustomSnackBarHelper(error.errors![0].message ?? getTranslated('not_found', Get.context!)!, isError: true, margin: tosterMargin);
    }
  }

  static ErrorResponseModel getError(ApiResponseModel apiResponse){
    ErrorResponseModel error;

    try{
      error = ErrorResponseModel.fromJson(apiResponse);
    }catch(e){
      if(apiResponse.error != null){
        error = ErrorResponseModel.fromJson(apiResponse.error);
      }else{
        error = ErrorResponseModel(errors: [Errors(code: '', message: apiResponse.error.toString())]);
      }
    }
    return error;
  }

    static Future<String> getStreamedResponseError(http.StreamedResponse response) async {
    String errorMessage = '${response.statusCode} ${response.reasonPhrase}';
    
    try {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseMap = jsonDecode(responseBody);
      
      ErrorResponseModel errorResponse = ErrorResponseModel.fromJson(responseMap);
      
      if (errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
        errorMessage = errorResponse.errors!.first.message ?? errorMessage;
      }
    } catch (e) {
      debugPrint('Error parsing response: $e');
    }
    
    return errorMessage;
  }

}