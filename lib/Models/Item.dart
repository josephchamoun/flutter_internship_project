class Item {
  final int? id;
  final String? name;
  final String? description;
  int? quantity; // Allow quantity to be nullable
  int? quantityInCart; // Allow quantityInCart to be nullable
  final double? price;
  final String? createdAt;
  final String? updatedAt;
  final int? categoryId;
  final String? gender;
  final String? age;
  final String? imageUrl; // Allow imageUrl to be nullable

  Item({
    this.id,
    this.name,
    this.description,
    this.quantity, // Allow quantity to be nullable
    this.quantityInCart, // Allow quantityInCart to be nullable
    this.price,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.gender,
    this.age,
    this.imageUrl, // Allow imageUrl to be nullable
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      quantityInCart: json['quantity_in_cart'],
      price: double.parse(json['price'].toString()),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryId: json['category_id'],
      gender: json['gender'],
      age: json['age'],
      // Ensure image URL is correctly formatted and encoded
      imageUrl: json['image_url'] != null
          ? Uri.encodeFull(json['image_url'].replaceAll(r'\/',
              '/')) // Replace double slashes with single slash and encode URL
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'item_id': id.toString(),
      'quantity': quantity,
    };
  }
}
