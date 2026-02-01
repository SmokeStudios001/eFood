class UserInfoModel {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? identityNumber;
  String? identityType;
  String? identityImage;
  String? image;
  String? password;
  String? createdAt;
  String? updatedAt;
  String? authToken;
  String? fcmToken;
  int? branchId;
  int? isActive;
  String? applicationStatus;
  int? loginHitCount;
  int? isTempBlocked;
  String? languageCode;
  int? ordersCount;
  int? deliveredOrdersCount;
  String? totalOrderAmount;

  UserInfoModel({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.identityNumber,
    this.identityType,
    this.identityImage,
    this.image,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.authToken,
    this.fcmToken,
    this.branchId,
    this.isActive,
    this.applicationStatus,
    this.loginHitCount,
    this.isTempBlocked,
    this.languageCode,
    this.ordersCount,
    this.deliveredOrdersCount,
    this.totalOrderAmount,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'],
      fName: json['f_name'],
      lName: json['l_name'],
      phone: json['phone'],
      email: json['email'],
      identityNumber: json['identity_number'],
      identityType: json['identity_type'],
      identityImage: json['identity_image'],
      image: json['image'],
      password: json['password'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      authToken: json['auth_token'],
      fcmToken: json['fcm_token'],
      branchId: json['branch_id'],
      isActive: json['is_active'],
      applicationStatus: json['application_status'],
      loginHitCount: json['login_hit_count'],
      isTempBlocked: json['is_temp_blocked'],
      languageCode: json['language_code'],
      ordersCount: json['orders_count'],
      deliveredOrdersCount: json['delivered_orders_count'],
      totalOrderAmount: json['total_order_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'f_name': fName,
      'l_name': lName,
      'phone': phone,
      'email': email,
      'identity_number': identityNumber,
      'identity_type': identityType,
      'identity_image': identityImage,
      'image': image,
      'password': password,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'auth_token': authToken,
      'fcm_token': fcmToken,
      'branch_id': branchId,
      'is_active': isActive,
      'application_status': applicationStatus,
      'login_hit_count': loginHitCount,
      'is_temp_blocked': isTempBlocked,
      'language_code': languageCode,
      'orders_count': ordersCount,
      'delivered_orders_count': deliveredOrdersCount,
      'total_order_amount': totalOrderAmount,
    };
  }
}