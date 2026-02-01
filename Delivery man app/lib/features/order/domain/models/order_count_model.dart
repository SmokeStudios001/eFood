class OrderCountModel {
  int? outForDelivery;

  OrderCountModel({this.outForDelivery});

  OrderCountModel.fromJson(Map<String, dynamic> json) {
    outForDelivery = json['out_for_delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['out_for_delivery'] = outForDelivery;
    return data;
  }
}