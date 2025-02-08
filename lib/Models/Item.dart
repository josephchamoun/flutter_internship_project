class Item {
  final int id;
  final String name;
  final String description;
  final int? quantity; // Allow quantity to be nullable
  final double price;
  final String createdAt;
  final String updatedAt;
  final int? categoryId;
  final String gender;
  final String? age;
  final String? imageUrl; // Allow imageUrl to be nullable

  Item({
    required this.id,
    required this.name,
    required this.description,
    this.quantity, // Allow quantity to be nullable
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    this.categoryId,
    required this.gender,
    this.age,
    this.imageUrl, // Allow imageUrl to be nullable
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'], // Allow quantity to be nullable
      price: double.parse(json['price'].toString()), // Parse price as double
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryId: json['category_id'],
      gender: json['gender'],
      age: json['age'],
      imageUrl: json['image_url'], // Allow imageUrl to be nullable
    );
  }
}
