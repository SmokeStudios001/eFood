import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_button_widget.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';


class CustomAlertDialogWidget extends StatelessWidget {
  final String? image;
  final IconData? icon;
  final String? title;
  final String? subTitle;
  final String? leftButtonText;
  final String? rightButtonText;
  final Function? onPressLeft;
  final Function? onPressRight;
  final Color? iconColor;
  final Widget? child;
  final Widget? iconWidget;
  final bool? isLoading;
  final Color? buttonColor;

  const CustomAlertDialogWidget({
    super.key, this.image, this.icon,
    this.title, this.subTitle, this.leftButtonText,
    this.rightButtonText, this.onPressLeft,  this.onPressRight,
    this.iconColor, this.child, this.isLoading = false, this.buttonColor, this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return _CustomAlertDialogShape(
      child: child ?? Container(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeLarge,
          horizontal: Dimensions.paddingSizeSmall,
        ),
        width: MediaQuery.sizeOf(context).width,
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          if(image != null) Image.asset(image!, width: 50),

          if(icon != null) Icon(icon!, size: 50, color: iconColor ?? Theme.of(context).colorScheme.error),

          if(iconWidget != null) iconWidget!,

          const SizedBox(height: Dimensions.paddingSizeDefault),

         if(title != null) Text(title!, style: rubikBold.copyWith(
            fontSize: Dimensions.fontSizeExtraLarge,
          ), textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeDefault),


          if(subTitle != null) Text(subTitle!, style: rubikRegular.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          ), textAlign: TextAlign.center),

          const SizedBox(height: 50),


          Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
            Flexible(child: CustomButtonWidget(
              isShowBorder: false,
              backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.1),
              btnTxt: leftButtonText ?? getTranslated('no', context),
              style: rubikMedium.copyWith(color: Theme.of(context).textTheme.titleMedium?.color, fontSize: Dimensions.fontSizeLarge),
              onTap: onPressLeft ?? ()=> Navigator.pop(context),
            )),
            const SizedBox(width: Dimensions.paddingSizeDefault),


            Flexible(child: CustomButtonWidget(
              backgroundColor: buttonColor,
              isLoading: isLoading ?? false,
              btnTxt:  rightButtonText ?? getTranslated('yes', context),
              onTap: onPressRight ?? ()=> Navigator.pop(context),
            )),

          ]),




        ]),
      ),
    );
  }
}


class _CustomAlertDialogShape extends StatelessWidget {
  final Widget child;
  const _CustomAlertDialogShape({required this.child});

  @override
  Widget build(BuildContext context) {
    return  Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 4, width: 40, decoration: BoxDecoration(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(25),
          )),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          child,

        ],
      ),
    );
  }
}
