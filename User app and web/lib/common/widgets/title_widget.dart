import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class TitleWidget extends StatelessWidget {
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isShowLeadingIcon;
  final bool isShowTrailingIcon;
  final String? title;
  final String? subTitle;
  final Function? onTap;
  final TextStyle? subTitleTextStyle;

  const TitleWidget({
    super.key, required this.title, this.onTap, this.subTitle,
    this.leadingIcon, this.isShowLeadingIcon = false, this.trailingIcon, this.isShowTrailingIcon = false, this.subTitleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

      Row(mainAxisSize: MainAxisSize.min, children: [
        if(isShowLeadingIcon && leadingIcon != null)...[
          const SizedBox(width: Dimensions.paddingSizeSmall),
          leadingIcon ?? const SizedBox(),
          const SizedBox(width: Dimensions.paddingSizeSmall),
        ],

        Text(title!, style: rubikBold),
      ]),

      if(isShowTrailingIcon && trailingIcon != null) trailingIcon!,

      if(onTap != null && !isShowTrailingIcon) InkWell(
        onTap: onTap as void Function()?,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Text(
            subTitle ?? getTranslated('view_all', context)!,
            style: subTitleTextStyle ?? rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    ]);
  }
}
