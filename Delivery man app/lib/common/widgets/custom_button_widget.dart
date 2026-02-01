import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function? onTap;
  final String? btnTxt;
  final Color? backgroundColor;
  final double radius;
  final IconData? iconData;
  final TextStyle? style;
  final bool isLoading;
  final double? height;
  final bool isShowBorder;
  final Color? borderColor;

  const CustomButtonWidget({
    super.key, this.onTap, required this.btnTxt, this.backgroundColor,
    this.radius = 10, this.iconData,
    this.style, this.isLoading = false,
    this.height,
    this.isShowBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onTap == null ? Theme.of(context).disabledColor : backgroundColor ?? (isShowBorder ? Colors.transparent : Theme.of(context).primaryColor),
      minimumSize: Size(MediaQuery.of(context).size.width, height ?? 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: isShowBorder ?  BorderSide(
          color: borderColor ?? Theme.of(context).hintColor.withValues(alpha:0.5),
        ) : BorderSide.none,
      ),
    );

    return TextButton(
      onPressed: isLoading ? null : onTap as void Function()?,
      style: flatButtonStyle,
      child: isLoading ?
      Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(
          height: 15, width: 15,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Text(getTranslated('loading', context)!, style: rubikBold.copyWith(color: Colors.white)),
      ]),
      ) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [

        Icon(iconData, color: Colors.white, size: iconData != null ? 20 : 0),
        SizedBox(width: iconData != null ?  Dimensions.paddingSizeSmall : 0),

        Text(
          btnTxt ?? "",
          style: style ?? rubikRegular.copyWith(
            color: isShowBorder ? Theme.of(context).textTheme.bodyMedium?.color :  Colors.white,
            fontSize: Dimensions.fontSizeLarge,
          ),
        ),

      ]),
    );
  }
}
