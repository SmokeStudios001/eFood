import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/providers/permission_handler_provider.dart';
import 'package:resturant_delivery_boy/common/providers/tracker_provider.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_asset_image_widget.dart';
import 'package:resturant_delivery_boy/common/widgets/paginated_list_widget.dart';
import 'package:resturant_delivery_boy/features/home/widgets/delivery_analytics_shimmer_widget.dart';
import 'package:resturant_delivery_boy/features/home/widgets/delivery_analytics_widget.dart';
import 'package:resturant_delivery_boy/features/home/widgets/location_permission_widget.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/orders_info_model.dart';
import 'package:resturant_delivery_boy/features/order/providers/order_provider.dart';
import 'package:resturant_delivery_boy/features/order/screens/order_details_screen.dart';
import 'package:resturant_delivery_boy/features/order/widgets/order_card_item_widget.dart';
import 'package:resturant_delivery_boy/features/profile/providers/profile_provider.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/helper/location_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: context.theme.cardColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.06), // Height of the AppBar
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.cardColor, // Background color of the AppBar
            boxShadow: [
              BoxShadow(
                color: context.theme.primaryColor.withValues(alpha:0.08), // Shadow color
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 4), // Offset of the shadow
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: context.theme.cardColor,
            centerTitle: false,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeSmall,
                bottom: Dimensions.paddingSizeExtraSmall,
              ),
              child: Row(children: [

                const CustomAssetImageWidget(Images.logo,
                  height: 50, width: 50,
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),


                Text(AppConstants.appName, style: rubikBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: context.theme.primaryColor,
                ))

              ]),
            ),
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async{
          orderProvider.getCurrentOrdersList(1, context);
          Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
          orderProvider.getDeliveryOrderStatistics(filter: orderProvider.deliveryAnalyticsTimeRangeEnum?.name);
        },
        child: CustomScrollView(controller: scrollController, slivers: [

          SliverToBoxAdapter(child: Consumer<PermissionHandlerProvider>(
            builder: (context, permissionProvider, child) {
              if(permissionProvider.isShownLocationWarning || permissionProvider.isShownNotificationWarning) {
                return InkWell(
                  onTap: () async {
                    if(permissionProvider.isShownNotificationWarning){
                      permissionProvider.setOpenSetting(true);
                      await Geolocator.openAppSettings();
                    }else{
                      if(permissionProvider.locationPermission == LocationPermission.always || permissionProvider.locationPermission == LocationPermission.whileInUse) {
                        LocationHelper.onLocationShowDialog(context, dialog: LocationPermissionWidget(
                          fromDashboard: true,
                          onPressed: () async {
                            Navigator.pop(context);
                            permissionProvider.setOpenSetting(true);
                            await Geolocator.openAppSettings();
                          },
                        ));
                      }else {
                        if(context.mounted) {
                          await LocationHelper.checkPermission(context);
                          LocationPermission permission = await Geolocator.checkPermission();

                          permissionProvider.setLocationPermission(permission);


                        }
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    color: Colors.black,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Flexible(child: Text(
                        getTranslated(permissionProvider.getWarningText(), context)!,
                        style: rubikRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                      )),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Container(
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_forward, color: Colors.black),
                      ),

                    ]),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )),


          SliverToBoxAdapter(child: Selector<OrderProvider, bool>(
            selector: (context, orderProvider)=> orderProvider.isLoading,
            builder: (context, isLoading, child) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                isLoading ? const DeliveryAnalyticsShimmerWidget() : const DeliveryAnalyticsWidget(),

              ]);
            }
          )),

          SliverToBoxAdapter(
            child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                Text(getTranslated('ongoing_orders', context)!,
                  style: rubikBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: context.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Selector<OrderProvider, OrdersInfoModel?>(
                    selector: (context, orderProvider) => orderProvider.currentOrderModel,
                    builder: (context, currentOrderModel, child) {

                      final OrderProvider orderProvider = Provider.of(context, listen: false);

                      return PaginatedListWidget(
                        onPaginate: (int? offset) async {
                          await orderProvider.getCurrentOrdersList(offset ?? 1, context);
                        },
                        scrollController: scrollController,
                        enabledPagination: true,
                        offset: int.parse(currentOrderModel?.offset ?? '0'),
                        totalSize: currentOrderModel?.totalSize,
                        itemView: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderProvider.currentOrders.length,
                          separatorBuilder: (context, index) => const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                          itemBuilder: (context, index) => InkWell(
                            onTap: () async {

                              if(orderProvider.currentOrders[index].orderStatus == 'out_for_delivery') {
                                LocationHelper.checkPermission(context, callBack: () {
                                  Provider.of<TrackerProvider>(context, listen: false).startListenCurrentLocation();
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: orderProvider.currentOrders[index].id)));
                                });

                              }else {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: orderProvider.currentOrders[index].id)));

                              }
                            },
                            child: OrderCardItemWidget(
                              orderModel: orderProvider.currentOrders[index],
                            ),
                          ),
                        ),
                      );
                    }
                )

              ]),
            ),
          )

        ]),
      ),
    );
  }
}








