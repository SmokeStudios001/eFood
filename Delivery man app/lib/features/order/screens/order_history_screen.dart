import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/features/order/widgets/order_list_shimmer_widget.dart';
import 'package:resturant_delivery_boy/helper/custom_debounce_helper.dart';
import 'package:resturant_delivery_boy/common/widgets/paginated_list_widget.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/orders_info_model.dart';
import 'package:resturant_delivery_boy/features/order/screens/order_details_screen.dart';
import 'package:resturant_delivery_boy/features/order/widgets/order_card_item_widget.dart';
import 'package:resturant_delivery_boy/helper/custom_extension_helper.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/features/order/providers/order_provider.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';


class OrderHistoryScreen extends StatefulWidget {

  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final ScrollController scrollController = ScrollController();
  final CustomDebounceHelper customDebounceHelper = CustomDebounceHelper(milliseconds: 500);


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          getTranslated('order_history', context)!,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          await Provider.of<OrderProvider>(context, listen: false).getOrderHistoryList(1, context, isReload: true);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Column(children: [

            Selector<OrderProvider, int>(
              selector: (context, orderProvider) => orderProvider.selectedSectionID,
              builder: (context, selectedSectionID, child) {

                final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

                return SizedBox(height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(width: Dimensions.paddingSizeDefault),
                      scrollDirection: Axis.horizontal,
                      itemCount: orderProvider.orderHistorySection.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: (){
                            orderProvider.setSelectedSectionID(value: index);
                            customDebounceHelper.run(() async{
                              await orderProvider.getOrderHistoryList(1, context, isReload: true);
                            });
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: selectedSectionID == index ? context.theme.primaryColor : context.theme.hintColor.withValues(alpha:0.1),
                              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeLarge,
                                vertical: Dimensions.paddingSizeSmall,
                              ),
                              child: Text(getTranslated(orderProvider.orderHistorySection[index], context)!,
                                style: selectedSectionID == index ? rubikBold.copyWith(
                                  color: context.theme.cardColor,
                                ): rubikRegular.copyWith(color: context.textTheme.bodyLarge?.color?.withValues(alpha:0.8)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Selector<OrderProvider, OrdersInfoModel?>(
              selector: (context, orderProvider) => orderProvider.orderHistoryModel,
              builder: (context, orderHistoryModel, child) {

                final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

                return (orderHistoryModel?.orders?.isNotEmpty ?? false) ? Expanded(
                  child: PaginatedListWidget(
                    scrollController: scrollController,
                    onPaginate: (int? offset) async {
                      await orderProvider.getOrderHistoryList(offset ?? 1, context);
                    },
                    totalSize: orderHistoryModel?.totalSize,
                    offset: int.parse(orderHistoryModel?.offset ?? '1'),
                    enabledPagination: true,
                    limit:  int.parse(orderHistoryModel?.limit ?? '10'),
                    itemView: Expanded(
                      child: ListView.separated(

                        controller: scrollController,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: orderProvider.orderHistoryList?.length ?? 0,
                        separatorBuilder: (context, index) => const SizedBox(height: Dimensions.paddingSizeDefault),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                                OrderDetailsScreen(orderId: orderProvider.orderHistoryList![index].id)));
                          },
                          child: OrderCardItemWidget(orderModel: orderProvider.orderHistoryList![index]),
                        ),
                      ),
                    ),
                  ),
                ) : orderHistoryModel == null ? const Expanded(child: OrderListShimmerWidget())
                : (orderHistoryModel.orders?.isEmpty ?? false) ? Center(
                  child: Padding(padding: const EdgeInsets.only(top: 130),
                    child: Text(getTranslated('no_data_found', context)!,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ): const SizedBox.shrink();
              }),


          ]),
        ),
      ),
    );
  }
}
