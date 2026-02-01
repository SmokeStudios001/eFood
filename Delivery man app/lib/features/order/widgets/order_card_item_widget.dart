import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/order_model.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/helper/date_converter_helper.dart';
import 'package:resturant_delivery_boy/helper/price_converter_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

class OrderCardItemWidget extends StatelessWidget {
  final OrderModel orderModel;

  const OrderCardItemWidget({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0,4),
            blurRadius: 5,
            spreadRadius: 0,
            color: context.customThemeColors.cardShadowColor.withValues(alpha:0.08),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeSmall,
            vertical: Dimensions.paddingSizeSmall,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              RichText(text: TextSpan(children: [

                TextSpan(text: getTranslated('order', context)!,
                  style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: context.textTheme.bodyLarge?.color,
                  ),
                ),

                TextSpan(text: "# ${orderModel.id}",
                  style: rubikMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: context.textTheme.bodyLarge?.color,
                  ),
                )

              ])),

              Text(getTranslated(orderModel.orderStatus, context)!,
                style: rubikSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: _getColorByStatus(orderModel.orderStatus, context)
                ),
              )

            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(DateConverterHelper.isoStringToLocalDateAndTime(
                orderModel.createdAt ?? ''),
              style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: context.theme.hintColor.withValues(alpha:0.5),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          ]),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeSmall,
            vertical: Dimensions.paddingSizeSmall,
          ),
          color: context.customThemeColors.lightGrayBackground,
          child: Column(children: [

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              Text('${orderModel.paymentMethod}'.removeUnderScore.capitalFirstLetter, style: rubikBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: context.customThemeColors.analyticsTextColor.withValues(alpha:0.7)
              )),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeExtraSmall,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: context.theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0,0),
                      blurRadius: 10,
                      spreadRadius: 0,
                      color: context.textTheme.bodyLarge!.color!.withValues(alpha:0.06),
                    ),
                  ],
                ),
                child: Text(PriceConverterHelper.convertPrice(context, (orderModel.orderAmount ?? 0) + (orderModel.deliveryCharge ?? 0)),
                  style: rubikMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: context.textTheme.bodyLarge?.color,
                  ),
                ),
              ),

            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          ]),
        )

      ]),
    );
  }

  Color _getColorByStatus(String? orderStatus, BuildContext context) {
    switch (orderStatus) {
      case 'pending':
        return context.customThemeColors.pendingColor;
      case 'confirmed':
        return context.customThemeColors.confirmedCardColor;
      case 'processing':
        return context.customThemeColors.processingCardColor;
      case 'out_for_delivery':
        return context.customThemeColors.outForDeliveryCardColor;
      case 'delivered':
        return context.customThemeColors.deliveredCountColor;
      default:
        return context.customThemeColors.errorColor;
    }
  }

}