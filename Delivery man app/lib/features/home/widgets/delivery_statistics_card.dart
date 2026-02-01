import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_asset_image_widget.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/helper/string_modification_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

class DeliveryStatisticsCard extends StatelessWidget {
  final int? orderNumber;
  final Color color;
  final String image;
  final String title;

  const DeliveryStatisticsCard({
    super.key, this.orderNumber, required this.color, required this.image, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          Dimensions.radiusSmall,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Align(alignment: Alignment.centerRight,
          child: CustomAssetImageWidget(
            image, height: 30, width: 30,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),


        Text(StringModificationHelper.addLeadingZero('${orderNumber ?? 0}'),
          style: rubikBold.copyWith(
            fontSize: Dimensions.fontSizeOverLarge,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),

        Text(getTranslated(title, context)!, style: rubikMedium.copyWith(
          fontSize: Dimensions.fontSizeSmall,
          color: context.customThemeColors.analyticsTextColor,
        )),

      ]),
    );
  }
}