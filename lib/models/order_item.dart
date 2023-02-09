// To parse this JSON data, do
//
//     final orderItem = orderItemFromJson(jsonString);

import 'dart:convert';

OrderItem orderItemFromJson(String str) => OrderItem.fromJson(json.decode(str));

String orderItemToJson(OrderItem data) => json.encode(data.toJson());

class OrderItem {
  OrderItem({
    required this.id,
    required this.productId,
    // required this.productName,
    // required this.productPrice,
    required this.quantity,
  });

  int id;
  int productId;
  // String productName;
  // double productPrice;
  int quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        productId: json.containsKey('product_id')
            ? json['product_id']
            : json["product"]["id"],
        // productName: json["product"]["book_name"],
        // productPrice: double.parse(json["product"]["unit_price"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        // "product_name": productName,
        // "product_price": productPrice,
        "quantity": quantity,
      };
}

class OrderItemError {
  int code;
  Object message;

  OrderItemError({required this.code, required this.message});
}
