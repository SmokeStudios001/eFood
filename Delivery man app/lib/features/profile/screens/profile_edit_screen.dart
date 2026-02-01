import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/models/response_model.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_app_bar_widget.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_button_widget.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_text_field_widget.dart';
import 'package:resturant_delivery_boy/features/auth/providers/auth_provider.dart';
import 'package:resturant_delivery_boy/features/profile/domain/models/userinfo_model.dart';
import 'package:resturant_delivery_boy/features/profile/providers/profile_provider.dart';
import 'package:resturant_delivery_boy/features/profile/widgets/profile_edit_image_widget.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/helper/show_custom_snackbar_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/main.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    _nameController.text = (profileProvider.userInfoModel?.fName ?? '') + (profileProvider.userInfoModel?.lName ?? '');
    _emailController.text = profileProvider.userInfoModel?.email ?? '';
    _phoneController.text = profileProvider.userInfoModel?.phone ?? '';

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.customThemeColors.offWhite,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBarWidget(
        title: getTranslated('edit_profile', context)!,
        isBackButtonExist: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeLarge,
        ),
        child: Column(children: [
        
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                      
                const ProfileEditImageWidget(),
                const SizedBox(height: 40),
                      
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Column(children: [
                      
                    CustomTextFieldWidget(
                      controller: _nameController,
                      isShowPrefixIcon: true,
                      prefixIconUrl: Images.user,
                      isShowBorder: true,
                      hintText: getTranslated('name_hint', context),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                      
                    CustomTextFieldWidget(
                      controller: _emailController,
                      isShowPrefixIcon: true,
                      prefixIconUrl: Images.emailIcon,
                      isShowBorder: true,
                      isEnabled: false,
                      hintText: getTranslated('email_hint', context),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                      
                    CustomTextFieldWidget(
                      inputType: TextInputType.phone,
                      controller: _phoneController,
                      isShowPrefixIcon: true,
                      prefixIconUrl: Images.phoneIcon,
                      isShowBorder: true,
                      hintText: getTranslated('phone_hint', context),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                      
                    CustomTextFieldWidget(
                      controller: _passwordController,
                      isShowPrefixIcon: true,
                      prefixIconUrl: Images.passwordIcon,
                      isShowBorder: true,
                      hintText: getTranslated('password_hint', context),
                      isPassword: true,
                      isShowSuffixIcon: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                      
                    CustomTextFieldWidget(
                      controller: _confirmPasswordController,
                      isShowPrefixIcon: true,
                      prefixIconUrl: Images.passwordIcon,
                      isShowBorder: true,
                      hintText: getTranslated('password_hint', context),
                      isPassword: true,
                      isShowSuffixIcon: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                      
                      
                  ]),
                ),
                      
              ]),
            ),
          ),
        
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault
            ),
            child: Row(children: [
        
              Expanded(child: CustomButtonWidget(
                btnTxt: getTranslated('cancel', context),
                isShowBorder: true,
                onTap: (){

                  final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);

                  _nameController.text = (profileProvider.userInfoModel?.fName ?? '') + (profileProvider.userInfoModel?.lName ?? '');
                  _phoneController.text = profileProvider.userInfoModel?.phone ?? '';

                  _passwordController.text = '';
                  _confirmPasswordController.text = '';

                },
                backgroundColor: context.theme.primaryColor.withValues(alpha:0.2),
                borderColor: Colors.transparent,
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),
        
              Expanded(child: CustomButtonWidget(
                btnTxt: getTranslated('update', context),
                onTap: ()=> _updateProfile(),
                backgroundColor: context.theme.primaryColor,
                borderColor: Colors.transparent,
              )),
        
            ]),
          )
        
        
        ]),
      ),
    );
  }
  
  
  
  Future<void> _updateProfile() async{
    if(_nameController.text.isEmpty){
      showCustomSnackBarHelper(getTranslated('please_enter_your_name', context)!);
    }else if(_emailController.text.isEmpty){
      showCustomSnackBarHelper(getTranslated('please_enter_your_email', context)!);
    }else if(_passwordController.text != _confirmPasswordController.text){
      showCustomSnackBarHelper(getTranslated('password_should_be', context)!);
    }else{

      final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);

      UserInfoModel updateUserInfoModel = UserInfoModel();
      updateUserInfoModel.fName = _nameController.text.split(' ').first.trim();
      updateUserInfoModel.lName = _nameController.text.replaceAll('${updateUserInfoModel.fName}', '').trim();
      updateUserInfoModel.phone = _phoneController.text.trim();

      ResponseModel responseModel = await profileProvider.updateUserInfo(
        updateUserInfoModel, _passwordController.text.trim(), profileProvider.file,
        Provider.of<AuthProvider>(context, listen: false).getUserToken(),
      );

      if(responseModel.isSuccess) {
        profileProvider.getUserInfo(Get.context!);

        if(context.mounted){
          _passwordController.clear();
          _confirmPasswordController.clear();
          showCustomSnackBarHelper(getTranslated('updated_successfully', Get.context!)!, isError: false);

        }
      }else {
        showCustomSnackBarHelper(responseModel.message!);
      }

    }
    
  }

  // _isNotChangeValues(){
  //   final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  //   return (
  //       _nameController.text.trim() == ((profileProvider.userInfoModel?.fName ?? '')
  //           + (profileProvider.userInfoModel?.lName ?? '')) &&
  //       _emailController.text.trim() == profileProvider.userInfoModel?.email
  //   );
  // }


}


