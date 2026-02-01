import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_alert_dialog_widget.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_app_bar_widget.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_asset_image_widget.dart';
import 'package:resturant_delivery_boy/features/auth/providers/auth_provider.dart';
import 'package:resturant_delivery_boy/features/auth/screens/login_screen.dart';
import 'package:resturant_delivery_boy/features/html/screens/html_viewer_screen.dart';
import 'package:resturant_delivery_boy/features/profile/domain/models/userinfo_model.dart';
import 'package:resturant_delivery_boy/features/profile/providers/profile_provider.dart';
import 'package:resturant_delivery_boy/features/profile/widgets/profile_info_card_widget.dart';
import 'package:resturant_delivery_boy/features/profile/widgets/profile_settings_card_widget.dart';
import 'package:resturant_delivery_boy/features/profile/widgets/profile_user_widget.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/helper/date_converter_helper.dart';
import 'package:resturant_delivery_boy/helper/price_converter_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.customThemeColors.offWhite,
      appBar: CustomAppBarWidget(
        title: getTranslated('my_profile', context),
        isBackButtonExist: false,
      ),
      body: SafeArea(child: Column(children: [

        Expanded(child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [

          const ProfileUserWidget(),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Selector<ProfileProvider, UserInfoModel?>(
            selector: (context, profileProvider) => profileProvider.userInfoModel,
            builder: (context, userInfoModel, child) {
              return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Row(children: [

                  ProfileInfoCardWidget(
                    image: Images.userIcon,
                    cardText: 'joining_date',
                    cardValue: (userInfoModel?.createdAt?.isNotEmpty ?? false)
                        ? DateConverterHelper.isoStringToLocalDateOnly(userInfoModel!.createdAt!)
                        : '',
                  ),
                              const SizedBox(width: Dimensions.paddingSizeDefault),
                              ProfileInfoCardWidget(
                                image: Images.orderIcon,
                                cardText: 'total_order',
                                cardValue: userInfoModel?.ordersCount.toString() ?? '0',
                              ),
                              const SizedBox(width: Dimensions.paddingSizeDefault),
                              ProfileInfoCardWidget(
                                image: Images.orderAmountIcon,
                                cardText: 'order_amount',
                                cardValue: PriceConverterHelper.convertPrice(
                                  context,
                                  double.tryParse(userInfoModel?.totalOrderAmount ?? '0'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          const ProfileSettingsCardWidget(
            isThemeSection: true,
            prefixImage: Images.themeIcon,
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HtmlViewerScreen(isPrivacyPolicy: true)),
            ),
            child: ProfileSettingsCardWidget(
              settingTitle: 'privacy_policy',
              prefixImage: Images.privacyPolicyIcon,
              suffixImage: Icon(
                Icons.arrow_forward_ios,
                color: context.textTheme.bodyLarge?.color,
                size: 14,
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HtmlViewerScreen(isPrivacyPolicy: false)),
            ),
            child: ProfileSettingsCardWidget(
              settingTitle: 'terms_and_conditions',
              prefixImage: Images.termsConditionsIcon,
              suffixImage: Icon(
                Icons.arrow_forward_ios,
                color: context.textTheme.bodyLarge?.color,
                size: 14,
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          InkWell(
            onTap: () => showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: false,
              context: context,
              builder: (ctx)=> Selector<AuthProvider, bool>(
                  selector: (ctx, authProvider) => authProvider.isLoading,
                  builder: (context, isLoading, child){
                    return CustomAlertDialogWidget(
                      title: getTranslated('are_you_sure_to_delete_your_account', context),
                      subTitle: getTranslated('all_your_personal_data_will_be_permanently_removed', context),
                      rightButtonText: getTranslated('delete', context),
                      leftButtonText: getTranslated('cancel', context),
                      isLoading: isLoading,
                      iconWidget: Container(
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                        child: const Padding(
                          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: CustomAssetImageWidget(Images.delete, color: Colors.white, width: 40, height: 40),
                        ),
                      ),
                      onPressRight: ()=> Provider.of<AuthProvider>(context, listen: false).deleteAccount(context),
                    );
                  }
              ),
            ),
            child: ProfileSettingsCardWidget(
              settingTitle: getTranslated('delete_account', context),
              prefixImage: Images.delete,
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),

          InkWell(
            onTap: () => showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: false,
              context: context,
              builder: (ctx)=> CustomAlertDialogWidget(
                title: getTranslated('want_to_sign_out', context),
                rightButtonText: getTranslated('yes', context),
                leftButtonText: getTranslated('no', context),
                iconWidget:  CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).cardColor,
                  child: Icon(Icons.contact_support, size: 50, color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
                onPressRight: () async {
                  await _signOut(context);

                },

              ),
            ),
            child: const ProfileSettingsCardWidget(
              settingTitle: 'logout',
              prefixImage: Images.logoutIcon,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),


        ]),)),

        Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          child: Align(alignment: Alignment.bottomCenter,
            child: Text("${getTranslated('app_version', context)} ${AppConstants.appVersion}",
              style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: context.theme.hintColor,
              ),
            ),
          ),
        ),

      ])),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    Navigator.pop(context);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
    await Provider.of<AuthProvider>(context, listen: false).clearSharedData();
  }
}

