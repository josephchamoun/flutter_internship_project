import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Controllers/CartController.dart';
import 'package:internship_mobile_project/Controllers/MainpageController.dart';
import 'package:internship_mobile_project/Models/Category.dart';
import 'package:internship_mobile_project/Models/Item.dart';
import 'package:internship_mobile_project/Views/profile.dart';
import '../components/custom_bottom_navbar.dart';
import 'cart.dart';
import 'myorders.dart';
import 'contact.dart';
import 'about.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Add this import

class Mainpage extends StatelessWidget {
  final MainpageController _mainpageController = Get.put(MainpageController());
  final CartController _cartController = Get.put(CartController());

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: _mainpageController.searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _mainpageController.searchTerm.value =
                        _mainpageController.searchController.text;
                    _mainpageController.applyFilters();
                  },
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Obx(() {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Age',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    value: _mainpageController.selectedAge.value.isEmpty
                        ? null
                        : _mainpageController.selectedAge.value,
                    items: [
                      'All Ages',
                      '0-3',
                      '3-6',
                      '6-9',
                      '9-12',
                      '13-17',
                      '18+'
                    ].map((String age) {
                      return DropdownMenuItem<String>(
                        value: age,
                        child: Text(age),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _mainpageController.selectedAge.value = value!;
                      _mainpageController.applyFilters();
                    },
                  );
                }),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Obx(() {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    value: _mainpageController.selectedGender.value.isEmpty
                        ? null
                        : _mainpageController.selectedGender.value,
                    items: ['male', 'female', 'both'].map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _mainpageController.selectedGender.value = value!;
                      _mainpageController.applyFilters();
                    },
                  );
                }),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Obx(() {
                  // Create a list of categories including "All Categories"
                  List<Category> categoriesWithAll = [
                    Category(id: -1, name: 'All'),
                    ..._mainpageController.categories
                  ];

                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Categories',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    value: _mainpageController.selectedCategory.value.isEmpty
                        ? null
                        : int.parse(_mainpageController.selectedCategory.value),
                    items: categoriesWithAll.map((Category category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _mainpageController.selectedCategory.value =
                          value.toString();
                      _mainpageController.applyFilters();
                    },
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: Obx(() {
              if (_mainpageController.items.isEmpty) {
                return const Center(
                    child: Text("No Items found.",
                        style: TextStyle(fontSize: 16)));
              }

              return ListView.builder(
                itemCount: _mainpageController.items.length,
                itemBuilder: (context, index) {
                  Item item = _mainpageController.items[index];
                  TextEditingController quantityController =
                      TextEditingController();

                  // Construct the full image URL if available

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        item.name ?? 'No Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.description ?? 'No Description'),
                          SizedBox(height: 8),
                          Text("Available Quantity: ${item.quantity ?? 'N/A'}"),
                          SizedBox(height: 8),
                          TextField(
                            controller: quantityController,
                            decoration: InputDecoration(
                              labelText: "Enter Quantity",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              String enteredQuantity = quantityController.text;

                              if (enteredQuantity.isNotEmpty) {
                                int quantity = int.parse(enteredQuantity);
                                if (item.quantity == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Item is out of stock. Please check back later."),
                                    ),
                                  );
                                } else if (quantity > 0 &&
                                    quantity <= item.quantity!) {
                                  _cartController.addToCart(item, quantity);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Invalid quantity. Please enter a value between 1 and ${item.quantity}."),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Please enter a quantity."),
                                  ),
                                );
                              }
                            },
                            child: Text("Add to Cart"),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 36),
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        "\$${item.price}",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _mainpageController.previousPage,
                child: const Text("Previous"),
              ),
              ElevatedButton(
                onPressed: _mainpageController.nextPage,
                child: const Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Epic Toy Store"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Get.to(() => CartView());
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Get.toNamed('/profile');
            },
          ),
        ],
      ),
      body: _buildMainContent(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _mainpageController.selectedIndex.value,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/mainpage'); // 🏠 Navigate to Main Page
              break;
            case 1:
              Get.offAllNamed('/myorders'); // 📦 Navigate to MyOrders
              break;
            case 2:
              Get.offAllNamed('/cart'); // 🛒 Navigate to Cart
              break;
            case 3:
              Get.offAllNamed('/about'); // ℹ️ Navigate to About
              break;
            default:
              Get.offAllNamed('/mainpage');
              break;
          }
        },
      ),
    );
  }
}
