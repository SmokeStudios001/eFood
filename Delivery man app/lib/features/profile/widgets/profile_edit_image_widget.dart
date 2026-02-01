import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_image_widget.dart';
import 'package:resturant_delivery_boy/features/profile/providers/profile_provider.dart';
import 'package:resturant_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/utill/images.dart';

class ProfileEditImageWidget extends StatelessWidget {
  const ProfileEditImageWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Center(child: Stack(clipBehavior: Clip.none, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: profileProvider.file != null ? Image.file(
              profileProvider.file!, fit: BoxFit.fill, height: 120, width: 120,
            ) : ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: CustomImageWidget(
                placeholder: Images.user,
                image: '${splashProvider.baseUrls?.deliveryManImageUrl}/${profileProvider.userInfoModel?.image}',
                height: 120, width: 120,
              ),
            ),
          ),

          Positioned(
            right: 5, bottom: -5,
            child: InkWell(
              onTap: ()=> profileProvider.choose(),
              child: CircleAvatar(
                radius: 27,
                backgroundColor: context.theme.cardColor,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: context.theme.primaryColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Icon(
                      Icons.camera_alt,
                      color: context.theme.cardColor,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
          )

        ],
        ));
      }
    );
  }
}