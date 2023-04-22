// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import 'package:share_learning/models/order_item.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

List<Order> ordersFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.id,
    required this.customerId,
    required this.items,
    required this.paymentStatus,
    required this.billingInfo,
    required this.deliveryInfo,
    required this.placedAt,
  });

  int id;
  int customerId;
  List<OrderItem> items;
  PaymentStatus paymentStatus;
  Map<String, dynamic>? billingInfo;
  Map<String, dynamic>? deliveryInfo;

  DateTime placedAt;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        customerId: json["customer"]["id"],
        items: List<OrderItem>.from(
            json["items"].map((x) => OrderItem.fromJson(x))),
        // paymentStatus: json["payment_status"],
        paymentStatus: paymentStatusFromString(json["payment_status"]),
        billingInfo: json["billing_info"],
        deliveryInfo: json["delivery_info"],
        placedAt: DateTime.parse(json["placed_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "payment_status": paymentStatusToString(paymentStatus),
        "billing_info": billingInfo,
        "delivery_info": deliveryInfo,
        "placed_at": placedAt.toIso8601String(),
      };

  static PaymentStatus paymentStatusFromString(String value) {
    switch (value) {
      case 'P':
        return PaymentStatus.PENDING;
      case 'C':
        return PaymentStatus.COMPLETE;
      case 'F':
        return PaymentStatus.FAILED;
      default:
        return PaymentStatus.PENDING;
    }
  }

  static String paymentStatusToString(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.PENDING:
        return "P";

      case PaymentStatus.COMPLETE:
        return "C";

      case PaymentStatus.FAILED:
        return "F";

      default:
        return "P";
    }
  }

  static DeliveryStatus deliveryStatusFromString(String value) {
    switch (value) {
      case 'D':
        return DeliveryStatus.DELIVERED;

      case 'T':
        return DeliveryStatus.IN_TRANSIT;

      case 'C':
        return DeliveryStatus.CANCELED;

      default:
        return DeliveryStatus.IN_TRANSIT;
    }
  }

  static String deliveryStatusToString(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.DELIVERED:
        return "D";

      case DeliveryStatus.IN_TRANSIT:
        return "T";

      case DeliveryStatus.CANCELED:
        return "C";

      default:
        return "D";
    }
  }

  static DeliveryMethod deliveryMethodFromString(String value) {
    switch (value) {
      case 'S':
        return DeliveryMethod.STANDARD;

      case 'E':
        return DeliveryMethod.EMERGENCY;

      default:
        return DeliveryMethod.STANDARD;
    }
  }

  static String deliveryMethodToString(DeliveryMethod method) {
    switch (method) {
      case DeliveryMethod.STANDARD:
        return "S";
      case DeliveryMethod.EMERGENCY:
        return "E";
      default:
        return "S";
    }
  }
}

class OrderError {
  int code;
  Object message;

  OrderError({required this.code, required this.message});
}

enum PaymentStatus {
  PENDING,
  COMPLETE,
  FAILED,
}

enum DeliveryStatus {
  IN_TRANSIT,
  DELIVERED,
  CANCELED,
}
enum DeliveryMethod {
  STANDARD,
  EMERGENCY,
}
