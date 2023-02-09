// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import 'package:share_learning/models/order_item.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.id,
    required this.customerId,
    required this.items,
    required this.paymentStatus,
    required this.billingInfo,
    required this.placedAt,
  });

  int id;
  int customerId;
  List<OrderItem> items;
  String paymentStatus;
  Map<String, dynamic>? billingInfo;
  DateTime placedAt;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        customerId: json["customer"]["id"],
        items: List<OrderItem>.from(
            json["items"].map((x) => OrderItem.fromJson(x))),
        paymentStatus: json["payment_status"],
        billingInfo: json["billing_info"],
        placedAt: DateTime.parse(json["placed_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "payment_status": paymentStatus,
        "billing_info": billingInfo,
        "placed_at": placedAt.toIso8601String(),
      };
}

class OrderError {
  int code;
  Object message;

  OrderError({required this.code, required this.message});
}
