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
  List<RequestedItem> requestedItems;

  OrderRequest({
    required this.id,
    required this.requestingCustomer,
    required this.requestedItems,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) => OrderRequest(
        id: json["id"],
        requestingCustomer:
            RequestingCustomer.fromJson(json["requesting_customer"]),
        requestedItems: List<RequestedItem>.from(
            json["requested_items"].map((x) => RequestedItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "requesting_customer": requestingCustomer.toJson(),
        "requested_items":
            List<dynamic>.from(requestedItems.map((x) => x.toJson())),
      };
}

class RequestedItem {
  int id;
  Product product;
  String requestedPrice;
  int quantity;

  RequestedItem({
    required this.id,
    required this.product,
    required this.requestedPrice,
    required this.quantity,
  });

  factory RequestedItem.fromJson(Map<String, dynamic> json) => RequestedItem(
        id: json["id"],
        product: Product.fromJson(json["product"]),
        requestedPrice: json["requested_price"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product.toJson(),
        "requested_price": requestedPrice,
        "quantity": quantity,
      };
}

class Product {
  int id;
  String bookName;
  String unitPrice;

  Product({
    required this.id,
    required this.bookName,
    required this.unitPrice,
  });

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
