import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class ReferHelper {
  static String generateReferralUrl(String? referCode)=> '${AppConstants.websiteUrl}${RouterHelper.createAccountScreen}?referral_code=${referCode ?? ''}';


}