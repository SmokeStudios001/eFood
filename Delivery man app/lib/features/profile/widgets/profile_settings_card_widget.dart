import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_asset_image_widget.dart';
import 'package:resturant_delivery_boy/features/profile/providers/theme_provider.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';


class ProfileSettingsCardWidget extends StatelessWidget {

  final bool? isThemeSection;
  final String prefixImage;
  final String? settingTitle;
  final Widget? suffixImage;

  const ProfileSettingsCardWidget({
    super.key,  this.isThemeSection = false, required this.prefixImage, this.settingTitle,
    this.suffixImage
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Card(
        color: context.theme.cardColor,
        elevation: 2,
        shadowColor: context.theme.primaryColor.withValues(alpha:0.05),
        child: Padding(padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: (isThemeSection ?? false) ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeDefault,
        ),
          child: Selector<ThemeProvider, bool>(
              selector: (context, themeProvider) => themeProvider.darkTheme,
              builder: (context, darkTheme, child) {

                final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

                return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                  Row(children: [

                    CustomAssetImageWidget(prefixImage, height: 20, width: 20),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Text(getTranslated( (isThemeSection ?? false) ? !darkTheme ? 'dark_mode' : 'light_mode' : settingTitle, context)!,
                      style: rubikMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: context.customThemeColors.analyticsTextColor,
                      ),
                    ),

                  ]),

                  (isThemeSection ?? false) ?
                  SizedBox(height: 30,
                    child: Switch(activeThumbColor: Colors.white,
                      activeTrackColor: context.theme.primaryColor,
                      inactiveTrackColor: context.theme.hintColor.withValues(alpha:0.3),
                      inactiveThumbColor: context.theme.cardColor,

                      trackOutlineColor: WidgetStateProperty. resolveWith<Color?>((Set<WidgetState> states) {
                        return Colors.transparent; // Use the default color.
                      }),
                      value: darkTheme,
                      onChanged: (bool value)=> themeProvider.toggleTheme(),
                    ),
                  ) : suffixImage ?? const SizedBox.shrink(),

                ]);
              }
          ),
        ),),
    );
  }
}