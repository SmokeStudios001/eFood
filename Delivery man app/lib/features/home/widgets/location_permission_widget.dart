import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_asset_image_widget.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

class LocationPermissionWidget extends StatelessWidget {
  final Function onPressed;
  final bool fromDashboard;
  const LocationPermissionWidget({super.key, required this.onPressed, this.fromDashboard = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: ()async {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.05),
                  shape: BoxShape.circle
              ),
              child: const Icon(Icons.clear, size: Dimensions.paddingSizeDefault),
            ),
          ),
        ),

        const Center(child: CustomAssetImageWidget(Images.locationPermission, width: 100, height: 100)),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        if(fromDashboard)...[
          Text(getTranslated('allow_background_location', context)!, style: rubikBold.copyWith(color: Theme.of(context).textTheme.titleSmall?.color)),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
            getTranslated('allow_the_app_to_run_in_the', context)!,
            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleSmall?.color?.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(getTranslated('how_to_do_it', context)!, style: rubikMedium.copyWith(color: Theme.of(context).textTheme.titleSmall?.color)),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin:const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              height: 7,width: 7,
              decoration: BoxDecoration(
                color: Theme.of(context).textTheme.titleSmall?.color?.withValues(alpha: 0.7),
                borderRadius: const BorderRadius.all(Radius.circular(100)),
              ),
            ),

            Expanded(child: Row(children: [
              Text(
                getTranslated('open', context)!,
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleSmall?.color?.withValues(alpha: 0.7)),
              ),

              Text(
                ' ${getTranslated('settings', context)!}',
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleSmall?.color),
              ),

            ])),
          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin:const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              height: 7,width: 7,
              decoration: BoxDecoration(
                color: Theme.of(context).textTheme.titleSmall?.color?.withValues(alpha: 0.7),
                borderRadius: const BorderRadius.all(Radius.circular(100)),
              ),
            ),

            Expanded(child: Row(children: [
              Text(
                getTranslated('go_to', context)!,
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleSmall?.color?.withValues(alpha: 0.7)),
              ),

              Text(
                ' ${getTranslated('permission_location', context)!}',
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleSmall?.color),
              ),
            ])),
          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin:const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              height: 7,width: 7,
              decoration: BoxDecoration(
                color: Theme.of(context).textTheme.titleSmall?.color?.withValues(alpha: 0.7),
                borderRadius: const BorderRadius.all(Radius.circular(100)),
              ),
            ),

            Expanded(child: Row(children: [
              Text(
                getTranslated('choose', context)!,
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleSmall?.color?.withValues(alpha: 0.7)),
              ),

              Text(
                ' ${getTranslated('allow_all_the_time', context)!}',
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleSmall?.color),
              ),
            ])),
          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        ]else...[
          Text(getTranslated('please_allow_location_access', context)!)
        ],
      ]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      actions: [InkWell(
        onTap: onPressed as void Function()?,
        child: Text(getTranslated('go_to_setting', context)!, style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),),
      )],
    );
  }
}
