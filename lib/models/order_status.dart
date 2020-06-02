import 'dart:convert';

import 'package:dropcure/models/order.dart';

class OrderStatus {
  bool status;
  String message;
  List<Order> data;

  OrderStatus({
    this.status,
    this.message,
    this.data,
  });

  factory OrderStatus.fromRawJson(String str) =>
      OrderStatus.fromJson(json.decode(str));

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
        status: json["status"],
        message: json["message"],
        data: json["data"].length > 0
            ? List<Order>.from(
                json["data"]["order"].map((x) => Order.fromJson(x)))
            : [],
      );
}
