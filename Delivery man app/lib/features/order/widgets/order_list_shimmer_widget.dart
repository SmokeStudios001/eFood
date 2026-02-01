import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';

class OrderListShimmerWidget extends StatelessWidget {
  const OrderListShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => const SizedBox(height: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemBuilder: (context, index) => const _OrderCardItemShimmerWidget(),
    );
  }
}

class _OrderCardItemShimmerWidget extends StatelessWidget {
  const _OrderCardItemShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 5,
            spreadRadius: 0,
            color: const Color(0xFF490000).withValues(alpha:0.08),
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
              Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  color: context.theme.hintColor.withValues(alpha:0.08),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
              Container(
                height: 20,
                width: 60,
                decoration: BoxDecoration(
                  color: context.theme.hintColor.withValues(alpha:0.08),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Container(
              height: 15,
              width: 150,
              decoration: BoxDecoration(
                color: context.theme.hintColor.withValues(alpha:0.08),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
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
              Container(
                height: 20,
                width: 120,
                decoration: BoxDecoration(
                  color: context.theme.hintColor.withValues(alpha:0.08),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
              Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 0,
                      color: context.textTheme.bodyLarge!.color!.withValues(alpha:0.06),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          ]),
        ),
      ]),
    );
  }
}
