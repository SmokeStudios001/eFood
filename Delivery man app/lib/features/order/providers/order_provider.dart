import 'dart:async';
import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/common/models/api_response_model.dart';
import 'package:resturant_delivery_boy/common/models/response_model.dart';
import 'package:resturant_delivery_boy/features/home/enums/delivery_analytics_time_range_enum.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/order_count_model.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/orders_info_model.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/delivery_order_statistics_model.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/order_details_model.dart';
import 'package:resturant_delivery_boy/features/order/domain/models/order_model.dart';
import 'package:resturant_delivery_boy/features/order/domain/reposotories/order_repo.dart';
import 'package:resturant_delivery_boy/helper/api_checker_helper.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepo? orderRepo;
  OrderProvider({required this.orderRepo});


  List<String> orderHistorySection = ['all', 'confirmed', 'processing', 'out_for_delivery', 'delivered', 'done', 'cooking', 'canceled', 'returned', 'failed', 'completed'];

  int _selectedSectionID = 0;

  DeliveryAnalyticsTimeRangeEnum? _deliveryAnalyticsTimeRangeEnum;
  List<OrderModel> _currentOrders = [];
  List<OrderModel> _currentOrdersReverse = [];
  OrdersInfoModel? _currentOrderModel;
  OrdersInfoModel? _orderHistoryModel;
  DeliveryOrderStatisticsModel? _deliveryOrderStatisticsModel;
  List<OrderDetailsModel>? _orderDetails;
  OrderModel? _orderDetailsModel;
  List<OrderModel>? _orderHistoryList;



  List<OrderModel>? get orderHistoryList => _orderHistoryList;
  OrdersInfoModel? get currentOrderModel => _currentOrderModel;
  OrdersInfoModel? get orderHistoryModel => _orderHistoryModel;
  DeliveryOrderStatisticsModel? get deliveryOrderStatisticsModel => _deliveryOrderStatisticsModel;
  List<OrderModel> get currentOrders => _currentOrders;
  OrderModel? get orderDetailsModel => _orderDetailsModel;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;
  int get selectedSectionID => _selectedSectionID;
  DeliveryAnalyticsTimeRangeEnum? get deliveryAnalyticsTimeRangeEnum => _deliveryAnalyticsTimeRangeEnum;

  Future<void> getCurrentOrdersList(int offset, BuildContext context) async {
    ApiResponseModel apiResponse = await orderRepo!.getAllOrders(offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      if(offset == 1){
        _currentOrders = [];
        _currentOrdersReverse = [];
      }
      _currentOrderModel = OrdersInfoModel.fromJson(apiResponse.response?.data);
      _currentOrderModel?.orders?.forEach((order) {
        _currentOrdersReverse.add(order);
      });

      _currentOrders = List.from(_currentOrdersReverse);

    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  // get order details

  Future<List<OrderDetailsModel>?> getOrderDetails(String orderID, BuildContext context) async {
    _orderDetails = null;
    ApiResponseModel apiResponse = await orderRepo!.getOrderDetails(orderID: orderID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response!.data.forEach((orderDetail) => _orderDetails!.add(OrderDetailsModel.fromJson(orderDetail)));
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
    return _orderDetails;
  }

  // Single order fetch state (for details screen)
  bool _isOrderLoading = false;
  String? _orderErrorMessage;

  bool get isOrderLoading => _isOrderLoading;
  String? get orderErrorMessage => _orderErrorMessage;

  Future<void> fetchOrderById(String orderID, BuildContext context) async {
    _isOrderLoading = true;
    _orderErrorMessage = null;
    _orderDetailsModel = null;
    _orderDetails = null;
    notifyListeners();

    try {
      final OrderModel? model = await getOrderModel(orderID);
      if (model == null) {
        _orderErrorMessage = 'Failed to load order';
        _isOrderLoading = false;
        notifyListeners();
        return;
      }
      if(context.mounted) {
        await getOrderDetails(orderID, context);

      }
    } catch (e) {
      _orderErrorMessage = e.toString();
    }
    _isOrderLoading = false;
    notifyListeners();
  }


  Future<OrderCountModel?> getOrdersCount() async {
  OrderCountModel? orderCountModel;
    ApiResponseModel apiResponse = await orderRepo!.getOrdersCount();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      orderCountModel= OrderCountModel.fromJson(apiResponse.response!.data);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    return orderCountModel;
  }
  
  

  Future<List<OrderModel>?> getOrderHistoryList(int offset, BuildContext context, {bool isUpdate = true, bool isReload = false}) async {

    if(isReload){
      _orderHistoryModel = null;
    }

    if(isUpdate){
      notifyListeners();
    }


    ApiResponseModel apiResponse = await orderRepo!.getAllOrderHistory(offset, orderHistorySection[selectedSectionID]);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {



      if(offset == 1){
        _orderHistoryList = [];
        _orderHistoryModel = OrdersInfoModel.fromJson(apiResponse.response?.data);
        _orderHistoryModel?.orders?.forEach((order) => _orderHistoryList?.add(order));
      }else{
        _orderHistoryModel = OrdersInfoModel.fromJson(apiResponse.response?.data);
         _orderHistoryList?.addAll(_orderHistoryModel?.orders ?? []);
      }

    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
    return _orderHistoryList;
  }


  // update Order Status
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? _feedbackMessage;

  String? get feedbackMessage => _feedbackMessage;

  Future<ResponseModel> updateOrderStatus({String? token, int? orderId, String? status}) async {
    _isLoading = true;
    _feedbackMessage = '';
    notifyListeners();
    ApiResponseModel apiResponse = await orderRepo!.updateOrderStatus(token: token, orderId: orderId, status: status);

    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
     // _currentOrdersReverse[index].orderStatus = status;
      _feedbackMessage = apiResponse.response!.data['message'];
      responseModel = ResponseModel(true, apiResponse.response?.data['message']);
    } else {
      _feedbackMessage = ApiCheckerHelper.getError(apiResponse).errors?[0].message;
      responseModel = ResponseModel(false, _feedbackMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future updatePaymentStatus({String? token, int? orderId, String? status}) async {
    await orderRepo!.updatePaymentStatus(token: token, orderId: orderId, status: status);
    notifyListeners();
  }

  // Future<List<OrderModel>?> refresh(BuildContext context) async{
  //   getCurrentOrdersList(1, context);
  //   Timer(const Duration(seconds: 5), () {});
  //   //return getOrderHistory(context);
  // }

  Future<OrderModel?> getOrderModel(String orderID) async {
    _orderDetailsModel = null;
    ApiResponseModel apiResponse = await orderRepo!.getOrderModel(orderID);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderDetailsModel = OrderModel.fromJson(apiResponse.response!.data);

    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
    return _orderDetailsModel;
  }


  Future<void> getDeliveryOrderStatistics({String? filter, bool isUpdate = true}) async {
    _isLoading = true;
    _deliveryOrderStatisticsModel = null;

    if(isUpdate){
      notifyListeners();
    }

    ApiResponseModel apiResponse = await orderRepo!.getDeliveryOrderStatistics(filter: filter);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _deliveryOrderStatisticsModel = DeliveryOrderStatisticsModel.fromJson(apiResponse.response?.data);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  void setSelectedSectionID ({int? value, bool isUpdate = true, bool? isReload = false}){
    if(isReload ?? false){
      _selectedSectionID = 0;
    }else{
      _selectedSectionID = value!;
    }


    if(isUpdate){
      notifyListeners();
    }
  }

  void setDeliveryAnalyticsTimeRangeEnum ({DeliveryAnalyticsTimeRangeEnum? value, bool isUpdate = true, bool? isReload = false}){
    if(isReload ?? false){
      _deliveryAnalyticsTimeRangeEnum = DeliveryAnalyticsTimeRangeEnum.allTime;
    }else{
      _deliveryAnalyticsTimeRangeEnum = value;
    }

    if(isUpdate){
      notifyListeners();
    }

  }



}
