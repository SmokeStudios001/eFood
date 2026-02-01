import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_asset_image_widget.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

class ProfileInfoCardWidget extends StatelessWidget {

  final String image;
  final String cardText;
  final String cardValue;

  const ProfileInfoCardWidget({
    super.key, required this.image, required this.cardText, required this.cardValue
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0,4),
            blurRadius: 4,
            spreadRadius: 0,
            color: Theme.of(context).primaryColor.withValues(alpha:0.05),
          ),
        ],
      ),
      child: Column(children: [

        CustomAssetImageWidget(
          image, height: 30, width: 30,
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(cardValue,
          style: rubikBold.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: context.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(getTranslated(cardText, context)!,
          style: rubikMedium.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: context.customThemeColors.analyticsTextColor.withValues(alpha:0.5),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

      ]),
    ));
  }
}