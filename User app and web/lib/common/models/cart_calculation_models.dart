import 'package:flutter_restaurant/common/models/cart_model.dart';

/// Helper class to encapsulate addons calculation results
class AddonsData {
  final double cost;
  final List<AddOn> addOnIdList;

  AddonsData({
    required this.cost,
    required this.addOnIdList,
  });
}

/// Helper class to encapsulate price calculation results
class PriceDetails {
  final double basePrice;
  final double priceWithVariation;
  final double priceWithDiscount;
  final double discountAmount;
  final double totalWithDiscount;
  final double totalWithoutDiscount;

  PriceDetails({
    required this.basePrice,
    required this.priceWithVariation,
    required this.priceWithDiscount,
    required this.discountAmount,
    required this.totalWithDiscount,
    required this.totalWithoutDiscount,
  });
}
