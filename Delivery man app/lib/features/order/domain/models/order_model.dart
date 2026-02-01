import 'dart:convert';

class OrderModel {
  int? id;
  int? userId;
  double? orderAmount;
  double? couponDiscountAmount;
  double? referralDiscount;
  String? couponDiscountTitle;
  String? paymentStatus;
  String? orderStatus;
  double? totalTaxAmount;
  String? paymentMethod;
  String? transactionReference;
  int? deliveryAddressId;
  String? createdAt;
  String? updatedAt;
  int? deliveryManId;
  double? deliveryCharge;
  String? orderNote;
  DeliveryAddress? deliveryAddress;
  Customer? customer;
  String? orderType;
  String? deliveryTime;
  String? deliveryDate;
  String? preparationTime;
  bool? isGuest;
  List<OrderPartialPayment>? orderPartialPayments;
  double? bringChangeAmount;

  OrderModel(
      {this.id,
        this.userId,
        this.orderAmount,
        this.couponDiscountAmount,
        this.referralDiscount,
        this.couponDiscountTitle,
        this.paymentStatus,
        this.orderStatus,
        this.totalTaxAmount,
        this.paymentMethod,
        this.transactionReference,
        this.deliveryAddressId,
        this.createdAt,
        this.updatedAt,
        this.deliveryManId,
        this.deliveryCharge,
        this.orderNote,
        this.deliveryAddress,
        this.customer,
        this.deliveryTime,
        this.deliveryDate,
        this.orderType,
        this.preparationTime,
        this.isGuest,
        this.orderPartialPayments,
        this.bringChangeAmount,
      });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderAmount = double.tryParse('${json['order_amount']}') ?? 0.0;
    couponDiscountAmount = double.tryParse('${json['coupon_discount_amount']}') ?? 0.0;
    referralDiscount = double.tryParse('${json['referral_discount']}') ?? 0.0;
    couponDiscountTitle = json['coupon_discount_title'];
    paymentStatus = json['payment_status'];
    orderStatus =  json['order_status'];
    totalTaxAmount = double.tryParse('${json['total_tax_amount']}') ?? 0.0;
    paymentMethod = json['payment_method'];
    transactionReference = json['transaction_reference'];
    deliveryAddressId = json['delivery_address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryManId = json['delivery_man_id'];
    deliveryCharge = double.tryParse('${json['delivery_charge']}') ?? 0.0;
    orderNote = json['order_note'];
    deliveryAddress = json['delivery_address'] != null
        ? DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    orderType = json['order_type'];
    deliveryTime = json['delivery_time'];
    deliveryDate = json['delivery_date'];
    preparationTime = json['preparation_time'].toString();
    isGuest = '${json['is_guest']}'.contains('1');
    orderPartialPayments = json["order_partial_payments"] == null ? [] : List<OrderPartialPayment>.from(json["order_partial_payments"]!.map((x) => OrderPartialPayment.fromMap(x)));
    bringChangeAmount =double.tryParse( json['bring_change_amount'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['order_amount'] = orderAmount;
    data['coupon_discount_amount'] = couponDiscountAmount;
    data['coupon_discount_title'] = couponDiscountTitle;
    data['payment_status'] = paymentStatus;
    data['order_status'] = orderStatus;
    data['total_tax_amount'] = totalTaxAmount;
    data['payment_method'] = paymentMethod;
    data['transaction_reference'] = transactionReference;
    data['delivery_address_id'] = deliveryAddressId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['delivery_man_id'] = deliveryManId;
    data['delivery_charge'] = deliveryCharge;
    data['order_note'] = orderNote;
    if (deliveryAddress != null) {
      data['delivery_address'] = deliveryAddress!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['order_type'] = orderType;
    data['delivery_time'] = deliveryTime;
    data['delivery_date'] = deliveryDate;
    data['is_guest'] = isGuest;
    data['bring_change_amount'] = bringChangeAmount;
    return data;
  }
}

class DeliveryAddress {
  int? id;
  String? addressType;
  String? contactPersonNumber;
  String? address;
  double? latitude;
  double? longitude;
  String? createdAt;
  String? updatedAt;
  int? userId;
  String? contactPersonName;

  DeliveryAddress(
      {this.id,
        this.addressType,
        this.contactPersonNumber,
        this.address,
        this.latitude,
        this.longitude,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.contactPersonName});

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    contactPersonNumber = json['contact_person_number'] ?? '';
    address = json['address'];
    latitude = double.tryParse('${json['latitude']}');
    longitude = double.tryParse('${json['longitude']}');
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    contactPersonName = json['contact_person_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address_type'] = addressType;
    data['contact_person_number'] = contactPersonNumber;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    data['contact_person_name'] = contactPersonName;
    return data;
  }
}

class Customer {
  int? id;
  String? fName;
  String? lName;
  String? email;
  String? image;
  int? isPhoneVerified;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? emailVerificationToken;
  String? phone;
  String? cmFirebaseToken;

  Customer(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.image,
        this.isPhoneVerified,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.emailVerificationToken,
        this.phone,
        this.cmFirebaseToken});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    isPhoneVerified = json['is_phone_verified'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emailVerificationToken = json['email_verification_token'];
    phone = json['phone'];
    cmFirebaseToken = json['cm_firebase_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['image'] = image;
    data['is_phone_verified'] = isPhoneVerified;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['email_verification_token'] = emailVerificationToken;
    data['phone'] = phone;
    data['cm_firebase_token'] = cmFirebaseToken;
    return data;
  }
}

class OrderPartialPayment {
  int? id;
  int? orderId;
  String? paidWith;
  double? paidAmount;
  double? dueAmount;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrderPartialPayment({
    this.id,
    this.orderId,
    this.paidWith,
    this.paidAmount,
    this.dueAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderPartialPayment.fromJson(String str) => OrderPartialPayment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderPartialPayment.fromMap(Map<String, dynamic> json) => OrderPartialPayment(
    id: json["id"],
    orderId: json["order_id"],
    paidWith: json["paid_with"],
    paidAmount: double.parse('${json["paid_amount"]}'),
    dueAmount: double.parse('${json["due_amount"]}'),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "order_id": orderId,
    "paid_with": paidWith,
    "paid_amount": paidAmount,
    "due_amount": dueAmount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}