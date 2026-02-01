class DeliveryOrderStatisticsModel {
  int? ongoingAssignedOrders;
  int? confirmedOrders;
  int? processingOrders;
  int? outForDeliveryOrders;
  int? deliveredOrders;
  int? canceledOrders;
  int? returnedOrders;
  int? failedOrders;

  DeliveryOrderStatisticsModel({
    this.ongoingAssignedOrders,
    this.confirmedOrders,
    this.processingOrders,
    this.outForDeliveryOrders,
    this.deliveredOrders,
    this.canceledOrders,
    this.returnedOrders,
    this.failedOrders,
  });

  factory DeliveryOrderStatisticsModel.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderStatisticsModel(
      ongoingAssignedOrders: json['ongoing_assigned_orders'],
      confirmedOrders: json['confirmed_orders'],
      processingOrders: json['processing_orders'],
      outForDeliveryOrders: json['out_for_delivery_orders'],
      deliveredOrders: json['delivered_orders'],
      canceledOrders: json['canceled_orders'],
      returnedOrders: json['returned_orders'],
      failedOrders: json['failed_orders'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ongoing_assigned_orders': ongoingAssignedOrders,
      'confirmed_orders': confirmedOrders,
      'processing_orders': processingOrders,
      'out_for_delivery_orders': outForDeliveryOrders,
      'delivered_orders': deliveredOrders,
      'canceled_orders': canceledOrders,
      'returned_orders': returnedOrders,
      'failed_orders': failedOrders,
    };
  }
}