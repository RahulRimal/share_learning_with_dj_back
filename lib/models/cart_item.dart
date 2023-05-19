// To parse this JSON data, do
//
//     final cartItem = cartItemFromJson(jsonString);

import 'dart:convert';

CartItem cartItemFromJson(String str) => CartItem.fromJson(json.decode(str));

String cartItemToJson(CartItem data) => json.encode(data.toJson());

class CartItem {
  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.negotiatedPrice,
    required this.totalPrice,
  });

  int id;
  Product product;
  int quantity;
  double negotiatedPrice;
  double totalPrice;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        product: Product.fromJson(json["product"]),
        quantity: json["quantity"],
        negotiatedPrice: double.parse(json["negotiated_price"]),
        totalPrice: json["total_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product.toJson(),
        "quantity": quantity,
        "negotiated_price": negotiatedPrice,
        "total_price": totalPrice,
      };
}

class Product {
  Product({
    required this.id,
    required this.bookName,
    required this.unitPrice,
  });

  int id;
  String bookName;
  String unitPrice;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        bookName: json["book_name"],
        unitPrice: json["unit_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "book_name": bookName,
        "unit_price": unitPrice,
      };
}

class CartItemError {
  int code;
  Object message;

  CartItemError({required this.code, required this.message});
}
