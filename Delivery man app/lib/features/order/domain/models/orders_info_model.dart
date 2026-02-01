import 'package:resturant_delivery_boy/features/order/domain/models/order_model.dart';

class OrdersInfoModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<OrderModel>? orders;

  OrdersInfoModel({
    this.totalSize,
    this.limit,
    this.offset,
    this.orders,
  });

  factory OrdersInfoModel.fromJson(Map<String, dynamic> json) {
    return OrdersInfoModel(
      totalSize: json['total_size'],
      limit: json['limit'],
      offset: json['offset'],
      orders: json['orders'] != null
          ? (json['orders'] as List).map((v) => OrderModel.fromJson(v)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_size': totalSize,
      'limit': limit,
      'offset': offset,
      'orders': orders?.map((v) => v.toJson()).toList(),
    };
  }
}
