class MyOrders {
  final int id;
  final String status;
  final String created_at;
  final int user_id;
  final String updated_at;
  final double total_amount;
  
  MyOrders({
    required this.id,
    required this.status,
    required this.user_id,
    required this.total_amount,
    required this.created_at,
    required this.updated_at,

  });

  factory MyOrders.fromJson(Map<String, dynamic> json) {
    return MyOrders(
      id: json['id'],
      status: json['status'],
      user_id: json['user_id'],
      total_amount: double.parse(json['total_amount'].toString()),
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }
}
