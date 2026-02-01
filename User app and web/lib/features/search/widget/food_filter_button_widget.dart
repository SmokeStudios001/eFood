import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:provider/provider.dart';


class FoodFilterButtonWidget extends StatelessWidget {
  final bool isVegSelected;
  final bool isNonVegSelected;
  final VoidCallback onVegToggle;
  final VoidCallback onNonVegToggle;
  final bool isBorder;
  final bool isSmall;

  const FoodFilterButtonWidget({
    super.key,
    required this.isVegSelected,
    required this.isNonVegSelected,
    required this.onVegToggle,
    required this.onNonVegToggle,
    this.isBorder = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (c, splashProvider, _) {
        return Visibility(
          visible: splashProvider.configModel!.isVegNonVegActive!,
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: ResponsiveHelper.isMobile() ? 35 : 40,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Veg button
                  _ToggleButton(
                    isSelected: isVegSelected,
                    onTap: onVegToggle,
                    imageUrl: Images.getImageUrl('veg'),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  // Non-veg button
                  _ToggleButton(
                    isSelected: isNonVegSelected,
                    onTap: onNonVegToggle,
                    imageUrl: Images.getImageUrl('non_veg'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}

class _ToggleButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String imageUrl;

  const _ToggleButton({
    required this.isSelected,
    required this.onTap,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).cardColor
            : Theme.of(context).hintColor.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
        border: isSelected
            ? Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.4))
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: CustomAssetImageWidget(imageUrl),
        ),
      ),
    );
  }
}

