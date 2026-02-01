import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_asset_image_widget.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_image_widget.dart';
import 'package:resturant_delivery_boy/features/profile/domain/models/userinfo_model.dart';
import 'package:resturant_delivery_boy/features/profile/providers/profile_provider.dart';
import 'package:resturant_delivery_boy/features/profile/screens/profile_edit_screen.dart';
import 'package:resturant_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

class ProfileUserWidget extends StatelessWidget {
  const ProfileUserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault).copyWith(
          top: Dimensions.paddingSizeDefault
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: context.theme.primaryColorLight ,
      ),
      child: Selector<ProfileProvider, UserInfoModel?>(
          selector: (context, profileProvider) => profileProvider.userInfoModel,
          builder: (context, userInfoModel, child) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                  Row(children: [

                    CircleAvatar(radius: 38, backgroundColor: context.theme.cardColor,
                      child: ClipRRect(borderRadius: BorderRadius.circular(40),
                        child: CustomImageWidget(
                          image: '${splashProvider.baseUrls?.deliveryManImageUrl}/${userInfoModel?.image}',
                          width: 70, height: 70, fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text('${userInfoModel?.fName ?? ''} ${userInfoModel?.lName ?? ''}',
                        style: rubikBold.copyWith(
                          color: context.theme.cardColor,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),

                      Text(userInfoModel?.phone ?? '',
                        style: rubikRegular.copyWith(
                          color: context.theme.cardColor,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),

                    ]),

                  ]),


                  InkWell(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfileEditScreen())),
                    child: const Align(alignment: Alignment.topRight,
                      child: CustomAssetImageWidget(Images.editIcon, height: 30, width: 30),
                    ),
                  ),

                ]);
          }
      ),
    );
  }
}