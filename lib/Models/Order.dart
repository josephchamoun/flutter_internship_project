import 'package:internship_mobile_project/Models/OrderDetails.dart';

class Order {
  final int? id;
  final String? status;
  final String? created_at;
  final String? user;
  final String? updated_at;
  final double total_amount;
  final List<OrderDetails>? cart;
  final int? user_id;

  Order({
    this.id,
    this.status,
    this.user,
    required this.total_amount,
    this.created_at,
    this.updated_at,
    this.cart,
    this.user_id,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'],
      user: json['user']['name'],
      total_amount: double.parse(json['total_amount'].toString()),
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      user_id: json['user_id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'user_id': user_id,
      'total_amount': total_amount,
      'cart': cart?.map((detail) => detail.toJson()).toList(),
    };
  }
}
