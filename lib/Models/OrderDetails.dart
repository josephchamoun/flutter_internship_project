import 'package:internship_mobile_project/Models/Item.dart';

class OrderDetails {
  final int? id;
  final int? order_id;
  final Item? item;
  final int quantity;

  OrderDetails({
    this.id,
    this.order_id,
    this.item,
    required this.quantity,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['id'],
      order_id: json['order_id'],
      item: json['item'] != null ? Item.fromJson(json['item']) : null,
      quantity: int.parse(json['quantity'].toString()),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'item_id': item?.id?.toString(),
      'quantity': quantity,
    };
  }
}
