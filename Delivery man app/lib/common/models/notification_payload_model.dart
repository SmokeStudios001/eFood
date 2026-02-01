import 'dart:convert';

class NotificationPayloadModel {
  NotificationPayloadModel({
    this.title,
    this.body,
    this.orderId,
    this.image,
    this.type,
    this.isAssignedNotification,
  });

  String? title;
  String? body;
  String? orderId;
  String? image;
  String? type;
  bool? isAssignedNotification;

  factory NotificationPayloadModel.fromRawJson(String str) => NotificationPayloadModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationPayloadModel.fromJson(Map<String, dynamic> json) => NotificationPayloadModel(
    title: json["title"],
    body: json["body"],
    orderId: json["order_id"],
    image: json["image"],
    type: json["type"],
    isAssignedNotification: json["is_deliveryman_assigned"] == '1',
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
    "order_id": orderId,
    "image": image,
    "type": type,
    "is_deliveryman_assigned": isAssignedNotification,
  };
}
