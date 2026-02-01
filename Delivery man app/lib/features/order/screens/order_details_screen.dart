import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_image_widget.dart';
import 'package:resturant_delivery_boy/features/dashboard/screens/dashboard_screen.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/order_details_model.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/order_model.dart';
import 'package:resturant_delivery_boy/features/order/widgets/product_type_widget.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/helper/date_converter_helper.dart';
import 'package:resturant_delivery_boy/helper/location_helper.dart';
import 'package:resturant_delivery_boy/helper/price_converter_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/features/auth/providers/auth_provider.dart';
import 'package:resturant_delivery_boy/features/language/providers/localization_provider.dart';
import 'package:resturant_delivery_boy/features/order/providers/order_provider.dart';
import 'package:resturant_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:resturant_delivery_boy/features/order/providers/time_provider.dart';
import 'package:resturant_delivery_boy/common/providers/tracker_provider.dart';
import 'package:resturant_delivery_boy/main.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_button_widget.dart';
import 'package:resturant_delivery_boy/features/chat/screens/chat_screen.dart';
import 'package:resturant_delivery_boy/features/order/screens/order_place_screen.dart';
import 'package:resturant_delivery_boy/features/order/widgets/custom_divider_widget.dart';
import 'package:resturant_delivery_boy/features/order/widgets/complete_order_dialog_widget.dart';
import 'package:resturant_delivery_boy/features/order/widgets/slider_button_widget.dart';
import 'package:resturant_delivery_boy/features/order/widgets/timer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int? orderId;
  const OrderDetailsScreen({super.key, this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  double? deliveryCharge = 0;

  @override
  void initState() {

    _loadData();


    super.initState();
  }

  Future<void> _loadData() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    orderProvider.getOrderDetails(widget.orderId.toString(), context);
    await orderProvider.getOrderModel('${widget.orderId}');

    if(_isOrderTypeDelivery(orderProvider.orderDetailsModel?.orderType)) {
      deliveryCharge = orderProvider.orderDetailsModel?.deliveryCharge ?? 0;
    }

    if(orderProvider.orderDetailsModel?.orderStatus != 'delivered' && mounted) {
      Provider.of<TimerProvider>(context, listen: false).countDownTimer(orderProvider.orderDetailsModel!, context);

    }

  }

  bool _isOrderTypeDelivery(String? orderType) => orderType == 'delivery';


  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _){
        if(didPop) return;

        if(Navigator.canPop(context)){
          Navigator.pop(context);
          return;
        } else if(!didPop && !Navigator.canPop(context) ){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const DashboardScreen()), (route)=> false);
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            onPressed: () {
              if(!Navigator.canPop(context)){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const DashboardScreen()), (route)=> false);
              } else{
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            getTranslated('order_details', context)!,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {


              // Consolidated status and visibility flags for clearer UI conditions
              final String? currentStatus = orderProvider.orderDetailsModel?.orderStatus;
              final bool isProcessing = currentStatus == 'processing';
              final bool isOutForDelivery = currentStatus == 'out_for_delivery';
              final bool isDone = currentStatus == 'done';
              final bool isDelivered = currentStatus == 'delivered';
              final bool isPending = currentStatus == 'pending';
              final bool isConfirmed = currentStatus == 'confirmed';
              final bool hasCustomerLatLng = orderProvider.orderDetailsModel?.deliveryAddress?.latitude != null;

              // UI visibility/behavior booleans
              final bool isTimerVisible = isPending || isConfirmed || isProcessing || isOutForDelivery;
              final bool isPaymentStatusVisible = isProcessing || isOutForDelivery;
              final bool isDirectionButtonActive = (isProcessing || isOutForDelivery) && hasCustomerLatLng;
              final bool isChatWithCustomerVisible = !isDelivered && !(orderProvider.orderDetailsModel?.isGuest ?? false);
              final bool isStartDeliverySliderVisible = isDone || isProcessing;
              final bool isConfirmDeliverySliderVisible = isOutForDelivery;
              

              double itemsPrice = 0; 
              double discount = 0;
              double tax = 0;
              double addOns = 0;

              double totalPrice = 0;
              if (orderProvider.orderDetails != null && orderProvider.orderDetailsModel != null) {

                for (var orderDetails in orderProvider.orderDetails!) {
                  List<double> addonPrices = orderDetails.addOnPrices ?? [];
                  List<int> addonsIds = orderDetails.addOnIds != null ? orderDetails.addOnIds! : [];

                  if(addonsIds.length == addonPrices.length &&
                      addonsIds.length == orderDetails.addOnQtys?.length){
                    for(int i = 0; i < addonsIds.length; i++){
                      addOns = addOns + (addonPrices[i] * orderDetails.addOnQtys![i]);
                    }
                  }

                  itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
                  discount = discount + (orderDetails.discountOnProduct! * orderDetails.quantity!);
                  tax = tax + (orderDetails.taxAmount! * orderDetails.quantity!) + orderDetails.addonTaxAmount!;
                }

                totalPrice = (itemsPrice + tax + addOns) - discount + deliveryCharge! - (orderProvider.orderDetailsModel?.couponDiscountAmount ?? 0) - (orderProvider.orderDetailsModel?.referralDiscount ?? 0) ;


              }

              List<OrderPartialPayment> paymentList = [];

              if(orderProvider.orderDetailsModel?.orderPartialPayments?.isNotEmpty ?? false){
                paymentList = [];
                paymentList.addAll(orderProvider.orderDetailsModel?.orderPartialPayments ?? []);

                if(orderProvider.orderDetailsModel?.paymentStatus == 'partial_paid'){
                  paymentList.add(OrderPartialPayment(
                    paidAmount: 0, paidWith: orderProvider.orderDetailsModel?.paymentMethod,
                    dueAmount: orderProvider.orderDetailsModel?.orderPartialPayments?.first.dueAmount,
                  ));
                }
              }


              return orderProvider.orderDetails != null && orderProvider.orderDetailsModel?.orderAmount != null ? Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      children: [
                        Row(children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('${getTranslated('order_id', context)}', style: rubikRegular),
                                Text(' # ${widget.orderId}', style: rubikMedium),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.watch_later, size: Dimensions.paddingSizeDefault),
                                const SizedBox(width: Dimensions.fontSizeLarge),

                                orderProvider.orderDetailsModel?.deliveryTime == null ? Flexible(
                                  child: Text(
                                    DateConverterHelper.isoStringToLocalDateOnly(orderProvider.orderDetailsModel!.createdAt!),
                                    style: rubikRegular,
                                    maxLines: 2,
                                  ),
                                ) : Flexible(
                                  child: Text(
                                    DateConverterHelper.deliveryDateAndTimeToDate(orderProvider.orderDetailsModel!.deliveryDate!, orderProvider.orderDetailsModel!.deliveryTime!, context),
                                    style: rubikRegular,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),

                        if(isTimerVisible) const TimerWidget(),


                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 5, spreadRadius: 1,
                            )],
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(getTranslated('customer', context)!, style: rubikRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                  )),
                                ],
                              ),
                            ),
                            ListTile(
                              leading: ClipOval(
                                child: CustomImageWidget(
                                  placeholder: Images.placeholderUser, height: 40, width: 40, fit: BoxFit.cover,
                                  image:'${splashProvider.baseUrls?.customerImageUrl}/${orderProvider.orderDetailsModel?.customer?.image}',
                                ),
                              ),
                              title: Text( orderProvider.orderDetailsModel?.deliveryAddress?.contactPersonName ?? "${orderProvider.orderDetailsModel?.customer?.fName ?? ""} ${orderProvider.orderDetailsModel?.customer?.lName ?? ""}"  ,
                                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                              ),
                              trailing: orderProvider.orderDetailsModel?.orderStatus != 'delivered' ?  InkWell(
                                onTap: orderProvider.orderDetailsModel?.deliveryAddress != null ?  () async {
                                  Uri uri = Uri.parse('tel:${orderProvider.orderDetailsModel?.deliveryAddress?.contactPersonNumber}');
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  } else {
                                    throw 'Could not launch $uri';
                                  }
                                } : null,
                                child: Container(
                                  padding: const EdgeInsets.all(Dimensions.fontSizeSmall),
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).shadowColor),
                                  child:  Icon(Icons.call_outlined, color: Theme.of(context).textTheme.bodyLarge?.color, size: 20,),
                                ),
                              ) : null,
                              visualDensity: VisualDensity.compact,

                            ),


                            if(orderProvider.orderDetailsModel?.deliveryAddress != null) Consumer<TrackerProvider>(
                                builder: (context, locationProvider, _) {
                                return ListTile(
                                  visualDensity: VisualDensity.compact,
                                  leading: const Icon(Icons.location_on_rounded, size: 20),
                                  horizontalTitleGap: Dimensions.paddingSizeExtraSmall,
                                  title: Text(orderProvider.orderDetailsModel?.deliveryAddress?.address ?? "", style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                  onTap: () {
                                    locationProvider.onChangeCurrentId(orderProvider.orderDetailsModel!.id!);

                                    LocationHelper.checkPermission(context, callBack: () async {

                                     await Provider.of<TrackerProvider>(context, listen: false).getUserCurrentLocation().then((position) {

                                        LocationHelper.openMap(
                                          destinationLatitude: double.tryParse('${orderProvider.orderDetailsModel?.deliveryAddress?.latitude}') ?? 0,
                                          destinationLongitude: double.tryParse('${orderProvider.orderDetailsModel?.deliveryAddress?.longitude}') ?? 0,
                                          userLatitude: position.latitude,
                                          userLongitude: position.longitude,
                                        );
                                      });
                                    });

                                  },

                                );
                              }
                            ),

                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Text('${getTranslated('item', context)}:', style: rubikRegular),
                              const SizedBox(width: Dimensions.fontSizeLarge),
                              Text(orderProvider.orderDetails!.length.toString(), style: rubikMedium),
                            ]),

                            isPaymentStatusVisible ? Row(children: [
                              Text('${getTranslated('payment_status', context)}:', style: rubikRegular),
                              const SizedBox(width: Dimensions.fontSizeLarge),
                              Text(getTranslated('${orderProvider.orderDetailsModel!.paymentStatus}', context)!,
                                  style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                            ])
                                : const SizedBox.shrink(),
                          ],
                        ),
                        const Divider(height: Dimensions.paddingSizeLarge),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderProvider.orderDetails!.length,
                          itemBuilder: (context, index) {
                            List<AddOns> addOns = [];
                            String variationText = '';

                            if(orderProvider.orderDetails![index].addOnIds != null){
                              for (var addOnsId in orderProvider.orderDetails![index].addOnIds!) {
                                for (var addons in orderProvider.orderDetails![index].productDetails!.addOns!) {
                                  if(addons.id == addOnsId) {
                                    addOns.add(addons);
                                  }
                                }
                              }
                            }

                            if(orderProvider.orderDetails![index].variations != null && orderProvider.orderDetails![index].variations!.isNotEmpty) {
                              for(Variation variation in orderProvider.orderDetails![index].variations!) {
                                variationText += '${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
                                for(VariationValue value in variation.variationValues!) {
                                  variationText += '${variationText.endsWith('(') ? '' : ', '}${value.level}';
                                }
                                variationText += ')';
                              }
                            }else if(orderProvider.orderDetails![index].oldVariations != null && orderProvider.orderDetails![index].oldVariations!.isNotEmpty) {
                              List<String> variationTypes = orderProvider.orderDetails![index].oldVariations![0].type!.split('-');
                              if(variationTypes.length == orderProvider.orderDetails![index].productDetails!.choiceOptions!.length) {
                                int index = 0;
                                for (var choice in orderProvider.orderDetails![index].productDetails!.choiceOptions!) {
                                  variationText = '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
                                  index = index + 1;
                                }
                              }else {
                                variationText = orderProvider.orderDetails![index].oldVariations![0].type ?? '';
                              }
                            }

                            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CustomImageWidget(
                                    placeholder: Images.placeholderImage, height: 70, width: 80, fit: BoxFit.cover,
                                    image: '${splashProvider.baseUrls?.productImageUrl}/${orderProvider.orderDetails?[index].productDetails?.image}',
                                  ),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Row(children: [

                                    Expanded(child: Text(
                                      orderProvider.orderDetails![index].productDetails!.name!,
                                      style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )),

                                    Text(getTranslated('amount', context)!, style: rubikRegular),

                                  ]),
                                  const SizedBox(height: Dimensions.fontSizeLarge),

                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                                    Row(children: [

                                      Text('${getTranslated('quantity', context)}:',
                                          style: rubikRegular
                                      ),

                                      Text(' ${orderProvider.orderDetails![index].quantity}',
                                          style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                                    ]),

                                    Text(
                                      PriceConverterHelper.convertPrice(context, orderProvider.orderDetails![index].price),
                                      style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                                    ),

                                  ]),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                  variationText != '' ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

                                    Container(height: 10, width: 10, decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).textTheme.bodyLarge!.color,
                                    )),
                                    const SizedBox(width: Dimensions.fontSizeLarge),

                                    Expanded(child: Text(variationText,
                                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    )),

                                  ]) :const SizedBox(),

                                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                    ProductTypeWidget(productType: orderProvider.orderDetails?[index].productDetails?.productType),

                                  ]) ,

                                ])),
                              ]),

                              addOns.isNotEmpty ? SizedBox(
                                height: 30,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                                  itemCount: addOns.length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                      child: Row(children: [
                                        Text(addOns[i].name!, style: rubikRegular),
                                        const SizedBox(width: 2),
                                        Text(
                                          PriceConverterHelper.convertPrice(context, addOns[i].price),
                                          style: rubikMedium,
                                        ),
                                        const SizedBox(width: 2),
                                        Text('(${orderProvider.orderDetails![index].addOnQtys![i]})', style: rubikRegular),
                                      ]),
                                    );
                                  },
                                ),
                              )
                                  : const SizedBox(),
                              const Divider(height: Dimensions.paddingSizeLarge),
                            ]);
                          },
                        ),

                        (orderProvider.orderDetailsModel?.orderNote != null && (orderProvider.orderDetailsModel?.orderNote!.isNotEmpty ?? false)) ? Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Theme.of(context).hintColor),
                          ),
                          child: Text(orderProvider.orderDetailsModel?.orderNote ?? '', style: rubikRegular.copyWith(color: Theme.of(context).hintColor)),
                        ) : const SizedBox(),

                        // Total
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(getTranslated('items_price', context)!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          Text(PriceConverterHelper.convertPrice(context, itemsPrice), style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        ]),
                        const SizedBox(height: 10),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(getTranslated('discount', context)!,
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          Text('(-) ${PriceConverterHelper.convertPrice(context, discount)}',
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        ]),
                        const SizedBox(height: 10),




                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(getTranslated('addons', context)!,
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          Text('(+) ${PriceConverterHelper.convertPrice(context, addOns)}',
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        ]),

                        const SizedBox(height: 10),

                        if((orderProvider.orderDetailsModel?.referralDiscount ?? 0) > 0)...[
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('referral_discount', context)!,
                                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                            Text(
                              '(-) ${PriceConverterHelper.convertPrice(context, orderProvider.orderDetailsModel?.referralDiscount)}',
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                            ),
                          ]),
                          const SizedBox(height: 10),
                        ],

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(getTranslated('coupon_discount', context)!,
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          Text(
                            '(-) ${PriceConverterHelper.convertPrice(context, orderProvider.orderDetailsModel?.couponDiscountAmount)}',
                            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                          ),
                        ]),
                        const SizedBox(height: 10),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(getTranslated('tax', context)!,
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          Text('(+) ${PriceConverterHelper.convertPrice(context, tax)}',
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        ]),
                        const SizedBox(height: 10),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(getTranslated('delivery_fee', context)!,
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          Text('(+) ${PriceConverterHelper.convertPrice(context, deliveryCharge)}',
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        ]),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: CustomDividerWidget(),
                        ),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(getTranslated('total_amount', context)!,
                              style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor)),
                          Text(
                            PriceConverterHelper.convertPrice(context, totalPrice),
                            style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor),
                          ),
                        ]),

                        if(orderProvider.orderDetailsModel?.orderPartialPayments != null && orderProvider.orderDetailsModel!.orderPartialPayments!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top:  Dimensions.paddingSizeDefault),
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                dashPattern: const [8, 4],
                                strokeWidth: 1.1,
                                color: Theme.of(context).colorScheme.primary,
                                radius: const Radius.circular(Dimensions.radiusDefault),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withValues(alpha:0.02),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall, vertical: 1),
                                child: Column(children: paymentList.map((payment) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                                    Text("${getTranslated(payment.paidAmount! > 0 ? 'paid_amount' : 'due_amount', context)} (${getTranslated('${payment.paidWith}', context)})",
                                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                                      overflow: TextOverflow.ellipsis,),

                                    Text( PriceConverterHelper.convertPrice(context, payment.paidAmount! > 0 ? payment.paidAmount : payment.dueAmount),
                                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),),
                                  ],
                                  ),
                                )).toList()),
                              ),
                            ),
                          ),


                        if(orderProvider.orderDetailsModel !=null && orderProvider.orderDetailsModel?.bringChangeAmount !=null && orderProvider.orderDetailsModel!.bringChangeAmount! > 0)Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          ),
                          margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),

                          child: RichText(text: TextSpan(children: [

                            TextSpan(text: getTranslated('please_bring', context)!,
                              style: rubikRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: context.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                              ),
                            ),

                            TextSpan(text: " ${PriceConverterHelper.convertPrice(context, orderProvider.orderDetailsModel?.bringChangeAmount)} ",
                              style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: context.textTheme.bodyLarge?.color,
                              ),
                            ),
                            TextSpan(text: getTranslated('in_change_for_customer', context)!,
                              style: rubikRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: context.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                              ),
                            ),

                          ])),


                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  isDirectionButtonActive
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Consumer<TrackerProvider>(
                        builder: (context, locationProvider, _) {
                          return CustomButtonWidget(
                              isLoading: locationProvider.isLoading && orderProvider.orderDetailsModel?.id == locationProvider.currentId,
                              btnTxt: getTranslated('direction', context),
                              onTap: () {
                                locationProvider.onChangeCurrentId(orderProvider.orderDetailsModel!.id!);

                                LocationHelper.checkPermission(context, callBack: () async {

                                  await Provider.of<TrackerProvider>(context, listen: false).getUserCurrentLocation().then((position) {

                                    LocationHelper.openMap(
                                      destinationLatitude: double.tryParse('${orderProvider.orderDetailsModel?.deliveryAddress?.latitude}') ?? 0,
                                      destinationLongitude: double.tryParse('${orderProvider.orderDetailsModel?.deliveryAddress?.longitude}') ?? 0,
                                      userLatitude: position.latitude,
                                      userLongitude: position.longitude,
                                    );
                                  });
                                });

                              });
                        },
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),

                  isChatWithCustomerVisible ? SafeArea(child: Center(
                    child: Container(
                      width: 1170,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: CustomButtonWidget(btnTxt: getTranslated('chat_with_customer', context), onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen(orderModel: orderProvider.orderDetailsModel)));
                      }),
                    ),
                  )) : const SizedBox(),

                  isStartDeliverySliderVisible ? Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha:.05)),
                      color: Theme.of(context).canvasColor,
                    ),
                    child: Transform.rotate(
                      angle: Provider.of<LocalizationProvider>(context).isLtr ? pi * 2 : pi, // in radians
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: SliderButtonWidget(
                          action: () {
                            LocationHelper.checkPermission(context, callBack: () async {
                              Provider.of<TrackerProvider>(context, listen: false).startListenCurrentLocation();

                              final String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();

                             await orderProvider.updateOrderStatus(
                                token: token,
                                orderId: orderProvider.orderDetailsModel!.id,
                                status: 'out_for_delivery',
                              );
                              await orderProvider.getOrderModel(widget.orderId.toString());

                              if(context.mounted) {
                                orderProvider.getCurrentOrdersList(1, context);
                                orderProvider.getOrderHistoryList(1, context);
                              }




                            });
                          },

                          ///Put label over here
                          label: Text(
                            getTranslated('swip_to_deliver_order', context)!,
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),
                          ),
                          dismissThresholds: 0.5,
                          width: MediaQuery.of(context).size.width - Dimensions.paddingSizeDefault,
                          dismissible: false,
                          icon: const Center(
                              child: Icon(
                                Icons.double_arrow_sharp,
                                color: Colors.white,
                                size: Dimensions.paddingSizeLarge,
                                semanticLabel: 'Text to announce in accessibility modes',
                              )),

                          ///Change All the color and size from here.
                          radius: 10,
                          boxShadow: const BoxShadow(blurRadius: 0.0),
                          buttonColor: Theme.of(context).primaryColor,
                          backgroundColor: Theme.of(context).canvasColor,
                          baseColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ) : isConfirmDeliverySliderVisible ? Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha:.05)),
                    ),
                    child: Transform.rotate(
                      angle: Provider.of<LocalizationProvider>(context).isLtr ? pi * 2 : pi, // in radians
                      child: Directionality(
                        textDirection: TextDirection.ltr, // set it to rtl
                        child: SliderButtonWidget(
                          action: () {
                            String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();

                            if (orderProvider.orderDetailsModel!.paymentStatus == 'paid') {

                              Provider.of<OrderProvider>(Get.context!, listen: false).getOrdersCount().then((orderCount){
                                if(orderCount !=null && orderCount.outForDelivery !=null && orderCount.outForDelivery! < 1){
                                  Provider.of<TrackerProvider>(Get.context!, listen: false).stopLocationService();
                                }
                              });

                              Provider.of<OrderProvider>(context, listen: false)
                                  .updateOrderStatus(token: token, orderId: orderProvider.orderDetailsModel!.id, status: 'delivered',);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => OrderPlaceScreen(orderID: orderProvider.orderDetailsModel!.id.toString())));
                            } else {
                              double payableAmount = totalPrice;

                              if(orderProvider.orderDetailsModel!.orderPartialPayments != null && orderProvider.orderDetailsModel!.orderPartialPayments!.isNotEmpty){
                                payableAmount = orderProvider.orderDetailsModel!.orderPartialPayments?[0].dueAmount ?? 0;
                              }
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                      child: CompleteOrderDialogWidget(
                                        onTap: () {},
                                        totalPrice: payableAmount,
                                        orderModel: orderProvider.orderDetailsModel,
                                      ),
                                    );
                                  });
                            }
                          },

                          ///Put label over here
                          label: Text(
                            getTranslated('swip_to_confirm_order', context)!,
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),
                          ),
                          dismissThresholds: 0.5,
                          width: MediaQuery.of(context).size.width - Dimensions.paddingSizeDefault,
                          dismissible: false,
                          icon: const Center(
                              child: Icon(
                                Icons.double_arrow_sharp,
                                color: Colors.white,
                                size: Dimensions.paddingSizeLarge,
                                semanticLabel: 'Text to announce in accessibility modes',
                              )),

                          ///Change All the color and size from here.
                          radius: 10,
                          boxShadow: const BoxShadow(blurRadius: 0.0),
                          buttonColor: Theme.of(context).primaryColor,
                          backgroundColor: Theme.of(context).cardColor,
                          baseColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),

                ],
              )
                  : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
            },
          ),
        ),
      ),
    );
  }

}
