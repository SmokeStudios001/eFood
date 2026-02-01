import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/features/home/enums/delivery_analytics_time_range_enum.dart';
import 'package:resturant_delivery_boy/features/home/widgets/delivery_statistics_card.dart';
import 'package:resturant_delivery_boy/features/home/widgets/horizontal_order_card_item.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/delivery_order_statistics_model.dart';
import 'package:resturant_delivery_boy/features/order/providers/order_provider.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

class DeliveryAnalyticsWidget extends StatelessWidget {
  const DeliveryAnalyticsWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0,4),
            blurRadius: 4,
            spreadRadius: 0,
            color: Theme.of(context).primaryColor.withValues(alpha:0.05),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeLarge,
      ),
      child: Column(children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Text(getTranslated('delivery_analytics', context)!,
            style: rubikMedium.copyWith(
              fontSize: Dimensions.paddingSizeDefault,
              color: context.textTheme.bodyLarge?.color,
            ),
          ),

          IntrinsicWidth(
            child: Selector<OrderProvider, DeliveryAnalyticsTimeRangeEnum?>(
              selector: (context, orderProvider) => orderProvider.deliveryAnalyticsTimeRangeEnum,
              builder: (context, timeRange, child) {

                final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

                return DropdownButtonFormField(
                  padding: EdgeInsets.zero,
                  initialValue: timeRange?.name,
                  style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: context.textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    suffixIcon: Container(width: 30,
                      height: 40, alignment: Alignment.center,
                      child: Icon(Icons.arrow_drop_down,
                        size: 30, color: Theme.of(context).primaryColor,
                      ), // Adjust icon size as needed
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      borderSide: BorderSide(
                        color: context.theme.tabBarTheme.indicatorColor!.withValues(alpha:0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      borderSide: BorderSide(
                        color: context.theme.tabBarTheme.indicatorColor!.withValues(alpha:0.5),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      borderSide: BorderSide(
                        color: context.theme.tabBarTheme.indicatorColor!.withValues(alpha:0.5),
                      ),
                    ),
                  ),
                  icon: const SizedBox.shrink(),
                  items: [
                    DropdownMenuItem(
                      value: DeliveryAnalyticsTimeRangeEnum.today.name,
                      child: Text(getTranslated(DeliveryAnalyticsTimeRangeEnum.today.name, context)!),
                    ),

                    DropdownMenuItem(
                      value: DeliveryAnalyticsTimeRangeEnum.thisWeek.name,
                      child: Text(getTranslated(DeliveryAnalyticsTimeRangeEnum.thisWeek.name, context)!),
                    ),

                    DropdownMenuItem(
                      value: DeliveryAnalyticsTimeRangeEnum.thisMonth.name,
                      child: Text(getTranslated(DeliveryAnalyticsTimeRangeEnum.thisMonth.name, context)!),
                    ),

                    DropdownMenuItem(
                      value: DeliveryAnalyticsTimeRangeEnum.thisYear.name,
                      child: Text(getTranslated(DeliveryAnalyticsTimeRangeEnum.thisYear.name, context)!),
                    ),

                    DropdownMenuItem(
                      value: DeliveryAnalyticsTimeRangeEnum.allTime.name,
                      child: Text(getTranslated(DeliveryAnalyticsTimeRangeEnum.allTime.name, context)!),
                    ),
                  ],

                onChanged: (String? value) {
                  if (value != null) {
                    final selectedRange = DeliveryAnalyticsTimeRangeEnum.values.firstWhere((e) => e.name == value);
                    orderProvider.setDeliveryAnalyticsTimeRangeEnum(value: selectedRange);
                    orderProvider.getDeliveryOrderStatistics(filter: selectedRange.name);
                  }
                },
                // Define the visible dropdown button style separately
                selectedItemBuilder: (BuildContext context) {
                  return DeliveryAnalyticsTimeRangeEnum.values.map((e) {
                    return Text(
                      getTranslated(e.name, context)!,
                      style: rubikRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    );
                  }).toList();
                },

                );
              }
            ),
          ),

        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Selector<OrderProvider, DeliveryOrderStatisticsModel?>(
            selector: (context, orderProvider) => orderProvider.deliveryOrderStatisticsModel,
            builder: (context, deliveryOrderStaticsModel, child) {
              return Column(children: [

                Row(children: [

                  Expanded(child: DeliveryStatisticsCard(
                      title: 'ongoing_assigned',
                      image: Images.assignedIcon,
                      orderNumber: deliveryOrderStaticsModel?.ongoingAssignedOrders,
                      color: context.customThemeColors.ongoingCardColor.withValues(alpha:0.07)
                  )),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Expanded(child: DeliveryStatisticsCard(
                    title: 'order_confirmed',
                    image: Images.confirmedIcon,
                    orderNumber: deliveryOrderStaticsModel?.confirmedOrders,
                    color: context.customThemeColors.confirmedCardColor.withValues(alpha:0.07),
                  )),

                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(children: [

                  Expanded(child: DeliveryStatisticsCard(
                      title: 'processing',
                      image: Images.processingIcon,
                      orderNumber: deliveryOrderStaticsModel?.processingOrders,
                      color: context.customThemeColors.processingCardColor.withValues(alpha:0.07)
                  )),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Expanded(child: DeliveryStatisticsCard(
                    title: 'out_for_delivery',
                    image: Images.outForDeliveryIcon,
                    orderNumber: deliveryOrderStaticsModel?.outForDeliveryOrders,
                    color: context.customThemeColors.outForDeliveryCardColor.withValues(alpha:0.07),
                  )),

                ]),

              ]);
            }
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Selector<OrderProvider, DeliveryOrderStatisticsModel?>(
          selector: (context, orderProvider) => orderProvider.deliveryOrderStatisticsModel,
          builder: (context, deliveryOrderStatisticsModel, child){
            return Container(
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0,0),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: context.theme.tabBarTheme.indicatorColor!.withValues(alpha:0.05),
                  ),

                  BoxShadow(
                    offset: const Offset(0,6),
                    blurRadius: 12,
                    spreadRadius: -3,
                    color: context.theme.tabBarTheme.indicatorColor!.withValues(alpha:0.05),
                  ),

                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeLarge,
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(getTranslated('completed_orders', context)!,
                  style: rubikBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: context.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                HorizontalOrderCardItem(
                  title: 'delivered',
                  image: Images.deliveredIcon,
                  color: context.customThemeColors.outForDeliveryCardColor,
                  orderNumber: deliveryOrderStatisticsModel?.deliveredOrders,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Divider(
                  color: context.theme.hintColor.withValues(alpha:0.05),
                  height: 1,
                  thickness: 1,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                HorizontalOrderCardItem(
                  title: 'canceled',
                  image: Images.canceledIcon,
                  color: context.customThemeColors.errorColor,
                  orderNumber: deliveryOrderStatisticsModel?.canceledOrders,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Divider(
                  color: context.theme.hintColor.withValues(alpha:0.08),
                  height: 1,
                  thickness: 2,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                HorizontalOrderCardItem(
                  title: 'returned',
                  image: Images.returnedIcon,
                  color: context.customThemeColors.errorColor,
                  orderNumber: deliveryOrderStatisticsModel?.returnedOrders,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Divider(
                  color: context.theme.hintColor.withValues(alpha:0.08),
                  height: 1,
                  thickness: 2,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                HorizontalOrderCardItem(
                  title: 'failed',
                  image: Images.failedIcon,
                  color: context.customThemeColors.errorColor,
                  orderNumber: deliveryOrderStatisticsModel?.failedOrders,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

              ]),
            );
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

      ]),
    );
  }
}