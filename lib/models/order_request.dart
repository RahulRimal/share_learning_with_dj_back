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
  Customer requestingCustomer;
  Customer requestedCustomer;

  RequestedProduct product;
  int quantity;
  String requestedPrice;
  // String? and bool? because they can be null for the first time
  String? sellerOfferPrice;
  bool? priceChangedBySeller;

  OrderRequest(
      {required this.id,
      required this.requestingCustomer,
      required this.requestedCustomer,
      required this.product,
      required this.quantity,
      required this.requestedPrice,
      required this.sellerOfferPrice,
      required this.priceChangedBySeller});

  factory OrderRequest.fromJson(Map<String, dynamic> json) => OrderRequest(
        id: json["id"],
        requestingCustomer: Customer.fromJson(json["requesting_customer"]),
        requestedCustomer: Customer.fromJson(json["requested_customer"]),
        product: RequestedProduct.fromJson(json["product"]),
        quantity: json["quantity"],
        requestedPrice: json["requested_price"],
        sellerOfferPrice: json["seller_offer_price"],
        priceChangedBySeller: json["changed_by_seller"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "requesting_customer": requestingCustomer.toJson(),
        "requested_customer": requestedCustomer.toJson(),
        "product": product.toJson(),
        "quantity": quantity,
        "requested_price": requestedPrice,
        "seller_offer_price": sellerOfferPrice,
        "changed_by_seller": priceChangedBySeller,
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

class Customer {
  int id;
  String firstName;
  String lastName;
  String email;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
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
