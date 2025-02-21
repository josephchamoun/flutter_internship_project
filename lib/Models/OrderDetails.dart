class OrderDetails {
  final int id;
  final int order_id;
  final String item;
  final int quantity;

  OrderDetails({
    required this.id,
    required this.order_id,
    required this.item,
    required this.quantity,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['id'],
      order_id: json['order_id'],
      item: json['item']['name'],
      quantity: int.parse(json['quantity'].toString()),
    );
  }
}
