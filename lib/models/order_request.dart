// To parse this JSON data, do
//
//     final orderRequest = orderRequestFromJson(jsonString);

import 'dart:convert';

List<OrderRequest> orderRequestsFromJson(String str) => List<OrderRequest>.from(
    json.decode(str).map((x) => OrderRequest.fromJson(x)));

OrderRequest orderRequestFromJson(String str) =>
    OrderRequest.fromJson(json.decode(str));

String orderRequestToJson(OrderRequest data) => json.encode(data.toJson());

class OrderRequest {
  String id;
  RequestingCustomer requestingCustomer;
  RequestedProduct product;
  int quantity;
  String requestedPrice;

  OrderRequest({
    required this.id,
    required this.requestingCustomer,
    required this.product,
    required this.quantity,
    required this.requestedPrice,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) => OrderRequest(
        id: json["id"],
        requestingCustomer:
            RequestingCustomer.fromJson(json["requesting_customer"]),
        product: RequestedProduct.fromJson(json["product"]),
        quantity: json["quantity"],
        requestedPrice: json["requested_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "requesting_customer": requestingCustomer.toJson(),
        "product": product.toJson(),
        "quantity": quantity,
        "requested_price": requestedPrice,
      };
}

class RequestedProduct {
  int id;
  String bookName;
  String unitPrice;

  RequestedProduct({
    required this.id,
    required this.bookName,
    required this.unitPrice,
  });

  factory RequestedProduct.fromJson(Map<String, dynamic> json) =>
      RequestedProduct(
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

class RequestingCustomer {
  int id;
  String firstName;
  String lastName;
  String email;

  RequestingCustomer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory RequestingCustomer.fromJson(Map<String, dynamic> json) =>
      RequestingCustomer(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
      };
}

class OrderRequestError {
  int code;
  Object message;

  OrderRequestError({required this.code, required this.message});
}
