
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/common/models/api_response_model.dart';
import 'package:resturant_delivery_boy/common/models/config_model.dart';
import 'package:resturant_delivery_boy/common/models/policy_model.dart';
import 'package:resturant_delivery_boy/features/maintenance/screens/maintenance_screen.dart';
import 'package:resturant_delivery_boy/features/splash/domain/reposotories/splash_repo.dart';
import 'package:resturant_delivery_boy/helper/api_checker_helper.dart';
import 'package:resturant_delivery_boy/main.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo? splashRepo;
  SplashProvider({required this.splashRepo});

  ConfigModel? _configModel;
  BaseUrls? _baseUrls;
  PolicyModel? _policyModel;


  ConfigModel? get configModel => _configModel;
  BaseUrls? get baseUrls => _baseUrls;
  PolicyModel? get policyModel => _policyModel;


  void _startTimer (DateTime startTime){
    Timer.periodic(const Duration(seconds: 30), (Timer timer){

      DateTime now = DateTime.now();

      if (now.isAfter(startTime) || now.isAtSameMomentAs(startTime)) {
        timer.cancel();
        Navigator.of(Get.context!).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MaintenanceScreen()), (route) => false
        );
      }

    });
  }


  Future<bool> initConfig(BuildContext context) async {
    ApiResponseModel apiResponse = await splashRepo!.getConfig();
    bool isSuccess;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);
      _baseUrls = ConfigModel.fromJson(apiResponse.response!.data).baseUrls;
      isSuccess = true;

      if(_configModel?.maintenanceMode?.maintenanceStatus == 0){
        if(_configModel?.maintenanceMode?.selectedMaintenanceSystem?.deliverymanApp == 1){
          if(_configModel?.maintenanceMode?.maintenanceTypeAndDuration?.maintenanceDuration == 'customize'){


            DateTime now = DateTime.now();
            DateTime specifiedDateTime = DateTime.parse(_configModel!.maintenanceMode!.maintenanceTypeAndDuration!.startDate!);

            Duration difference = specifiedDateTime.difference(now);

            if(difference.inMinutes > 0 && (difference.inMinutes < 60 || difference.inMinutes == 60)){
              _startTimer(specifiedDateTime);
            }

          }
        }
      }

      notifyListeners();
    } else {
      isSuccess = false;
      ApiCheckerHelper.checkApi(apiResponse);
    }
    return isSuccess;
  }

  Future<bool> getPolicyPage() async {
    ApiResponseModel apiResponse = await splashRepo!.getPolicyPage();
    bool isSuccess;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _policyModel = PolicyModel.fromJson(apiResponse.response!.data);
      isSuccess = true;
      notifyListeners();
    } else {
      isSuccess = false;
      ApiCheckerHelper.checkApi(apiResponse);
    }

    return isSuccess;
  }


  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }


}