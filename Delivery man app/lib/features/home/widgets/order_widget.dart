import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/order_model.dart';
import 'package:resturant_delivery_boy/helper/location_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/features/language/providers/localization_provider.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_button_widget.dart';
import 'package:resturant_delivery_boy/features/order/screens/order_details_screen.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final int index;
  const OrderWidget({super.key, this.orderModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha:.5), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 1))
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      // decoration: BoxDecoration(
      //     boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha:.5), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 1))],
      //     color: Theme.of(context).cardColor,
      //     borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    getTranslated('order_id', context)!,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                  Text(
                    ' # ${orderModel!.id.toString()}',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                ],
              ),
              Stack(
                clipBehavior: Clip.none, children: [
                  Container(),
                  Provider.of<LocalizationProvider>(context).isLtr
                      ? Positioned(
                          right: -10,
                          top: -23,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.fontSizeLarge, horizontal: Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(Dimensions.paddingSizeSmall),
                                    bottomLeft: Radius.circular(Dimensions.paddingSizeSmall))),
                            child: Text(
                              getTranslated('${orderModel?.orderStatus}', context)!,
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white),
                            ),
                          ),
                        )
                      : Positioned(
                          left: -10,
                          top: -28,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.fontSizeLarge, horizontal: Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(Dimensions.paddingSizeSmall),
                                    bottomLeft: Radius.circular(Dimensions.paddingSizeSmall))),
                            child: Text(
                              getTranslated('${orderModel!.orderStatus}', context)!,
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Image.asset(Images.location, color: Theme.of(context).textTheme.bodyLarge!.color, width: 15, height: 20),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(
                orderModel?.deliveryAddress?.address  ?? '${getTranslated('address_not_found', context)}',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
              )),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                  child: CustomButtonWidget(
                btnTxt: getTranslated('view_details', context),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: orderModel?.id)));
                },
                isShowBorder: true,
              )),

              if(orderModel?.deliveryAddress?.latitude != null && orderModel?.deliveryAddress?.longitude != null)...[
                const SizedBox(width: 20),

                Expanded(child: CustomButtonWidget(
                  btnTxt: getTranslated('direction', context),
                  onTap: ()=> LocationHelper.checkPermission(context, callBack: () async {

                    final position = await Geolocator.getCurrentPosition();

                    LocationHelper.openMap(
                      destinationLatitude: orderModel?.deliveryAddress?.latitude ?? 0,
                      destinationLongitude: orderModel?.deliveryAddress?.longitude ?? 0,
                      userLatitude: position.latitude,
                      userLongitude: position.longitude,
                    );
                  }),
                )),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

