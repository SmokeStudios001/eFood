import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_asset_image_widget.dart';
import 'package:resturant_delivery_boy/features/language/providers/localization_provider.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/helper/string_modification_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

class HorizontalOrderCardItem extends StatelessWidget {

  final String title;
  final String image;
  final Color color;
  final int? orderNumber;

  const HorizontalOrderCardItem({
    super.key, required this.title, required this.image, required this.color, this.orderNumber
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        return Row(children: [

          Align(
            alignment: localizationProvider.isLtr ? Alignment.topLeft : Alignment.topRight,
           child: CustomAssetImageWidget(image, height: 20, width: 20),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Text(getTranslated(title, context)!, style: rubikRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: context.textTheme.bodyLarge?.color,
          )),

          Expanded(child: Container()),

          Align(
            alignment: localizationProvider.isLtr ? Alignment.topLeft : Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeExtraSmall,
              ),
              decoration: BoxDecoration(
                color: context.customThemeColors.lightGrayBackground,
                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              ),
              child: Text(StringModificationHelper.addLeadingZero('${orderNumber ?? 0}'), style: rubikBold.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: color,
              )),
            ),
          )

        ]);
      }
    );
  }
}