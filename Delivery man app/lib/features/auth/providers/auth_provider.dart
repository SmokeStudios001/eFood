import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/models/response_model.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:resturant_delivery_boy/features/auth/domain/models/delivery_man_model.dart';
import 'package:resturant_delivery_boy/common/models/api_response_model.dart';
import 'package:resturant_delivery_boy/common/models/error_response_model.dart';
import 'package:resturant_delivery_boy/common/models/config_model.dart';
import 'package:resturant_delivery_boy/features/auth/domain/reposotories/auth_repo.dart';
import 'package:resturant_delivery_boy/features/auth/screens/login_screen.dart';
import 'package:resturant_delivery_boy/helper/api_checker_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/main.dart';
import 'package:resturant_delivery_boy/helper/show_custom_snackbar_helper.dart';
import 'package:http/http.dart' as http;


import '../../splash/providers/splash_provider.dart';
import '../../../helper/file_validation_helper.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo? authRepo;

  AuthProvider({required this.authRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // for login section
  String? _loginErrorMessage = '';

  String? get loginErrorMessage => _loginErrorMessage;

  XFile? _pickedImage;
  List<XFile> _pickedIdentities = [];
  final List<String> _identityTypeList = ['passport', 'driving_license', 'nid', 'restaurant_id'];
  int _identityTypeIndex = 0;
  final int _dmTypeIndex = 0;
  XFile? _pickedLogo;
  XFile? _pickedCover;
  int? _selectedBranchIndex;
  List<Branches>? _branchList;

  List<String> get identityTypeList => _identityTypeList;
  XFile? get pickedImage => _pickedImage;
  List<XFile> get pickedIdentities => _pickedIdentities;
  int get identityTypeIndex => _identityTypeIndex;
  int get dmTypeIndex => _dmTypeIndex;
  XFile? get pickedLogo => _pickedLogo;
  XFile? get pickedCover => _pickedCover;
  List<Branches>? get branchList => _branchList;
  int? get selectedBranchIndex => _selectedBranchIndex;

  void onChangeIsLoading(bool isLoading, {bool notify = true}) {
    _isLoading = isLoading;

    if (notify) {
      notifyListeners();
    }
  }

  Future<ResponseModel> login({String? emailAddress, String? password}) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.login(emailAddress: emailAddress, password: password);

    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String token = map["token"];
      authRepo!.saveUserToken(token);
      responseModel = ResponseModel(true, '');
     try{
       await updateToken();
     }catch(e){
       if (kDebugMode) {
         print(e);
       }
     }
    } else {
      _loginErrorMessage = ApiCheckerHelper.getError(apiResponse).errors![0].message;
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> updateToken() async {
    ApiResponseModel apiResponse = await   authRepo!.updateToken();
    if(apiResponse.response?.statusCode == null || apiResponse.response!.statusCode! != 200) {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  // for Remember Me Section

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  void onChangeRememberStatus() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  bool isLoggedIn() {
    return authRepo!.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authRepo!.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo!.saveUserNumberAndPassword(number, password);
  }

  String getUserEmail() {
    return authRepo!.getUserEmail();
  }

  String getUserPassword() {
    return authRepo!.getUserPassword();
  }

  Future<bool> clearUserEmailAndPassword() async {
    return authRepo!.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo!.getUserToken();
  }


  void getBranchList(){
    _branchList = [];

    _branchList?.add(Branches(id: 0, name: getTranslated('all', Get.context!)));
    _branchList?.addAll(Provider.of<SplashProvider>(Get.context!, listen: false).configModel?.branches ?? []);
  }

  void pickDmImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedImage = null;
      _pickedIdentities = [];
    }else {
      if (isLogo) {
        _pickedImage = await FileValidationHelper.validateAndPickImage(
          context: Get.context!,
          source: ImageSource.gallery,
        );
      } else {
        XFile? xFile = await FileValidationHelper.validateAndPickImage(
          context: Get.context!,
          source: ImageSource.gallery,
                                                                                                                                                                           );
        if(xFile != null) {
          _pickedIdentities.add(xFile);
        }
      }
      notifyListeners();
    }
  }

  void setIdentityTypeIndex(String? identityType, bool notify) {
    int index0 = 0;
    for(int index=0; index<_identityTypeList.length; index++) {
      if(_identityTypeList[index] == identityType) {
        index0 = index;
        break;
      }
    }
    _identityTypeIndex = index0;
    if(notify) {
      notifyListeners();
    }
  }



  void removeIdentityImage(int index) {
    _pickedIdentities.removeAt(index);
    notifyListeners();
  }

  Future<void> registerDeliveryMan(DeliveryManModel deliveryManBody) async {
    _isLoading = true;
    notifyListeners();
    List<MultipartBody> multiParts = [];
    multiParts.add(MultipartBody('image', _pickedImage));
    for(XFile file in _pickedIdentities) {
      multiParts.add(MultipartBody('identity_image[]', file));
    }
    http.Response ? apiResponse = await authRepo?.registerDeliveryMan(deliveryManBody, multiParts);
    if (apiResponse != null  && apiResponse.statusCode == 200) {
      Navigator.of(Get.context!).pop();
      showCustomSnackBarHelper(getTranslated('delivery_man_registration_successful', Get.context!)!, isError: false);
    } else {
      dynamic errorResponse;
      try{
        errorResponse = ErrorResponseModel.fromJson(jsonDecode(apiResponse!.body.toString())).errors![0].message;
      }catch(er){
        errorResponse = apiResponse?.body;
      }
      showCustomSnackBarHelper(errorResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  void setBranchIndex(int index, {bool isUpdate = true}){
    _selectedBranchIndex = index;
    if(isUpdate){
      notifyListeners();
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    ApiResponseModel response = await authRepo!.deleteAccount();

    _isLoading = false;
    notifyListeners();

    if (response.response?.statusCode == 200) {
      Provider.of<SplashProvider>(Get.context!, listen: false).removeSharedData();

      if(context.mounted) {
        showCustomSnackBarHelper(
          getTranslated('your_account_delete_successfully', context)!,
          isToast: true,
        );
      }

      Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);

    }else{
      if(context.mounted) {
        Navigator.of(context).pop();
      }
      ApiCheckerHelper.checkApi(response, tosterMargin: EdgeInsets.zero);
    }
  }
}
