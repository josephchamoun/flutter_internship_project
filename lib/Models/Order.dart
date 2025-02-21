class Order {
  final int id;
  final String status;
  final String created_at;
  final String user;
  final String updated_at;
  final double total_amount;

  Order({
    required this.id,
    required this.status,
    required this.user,
    required this.total_amount,
    required this.created_at,
    required this.updated_at,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'],
      user: json['user']['name'],
      total_amount: double.parse(json['total_amount'].toString()),
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }
}
