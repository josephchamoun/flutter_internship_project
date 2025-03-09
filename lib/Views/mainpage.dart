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
import 'package:cached_network_image/cached_network_image.dart';

class Mainpage extends StatelessWidget {
  final MainpageController _mainpageController = Get.put(MainpageController());
  final CartController _cartController = Get.put(CartController());

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          16.0, 16.0, 16.0, 8.0), // Reduced bottom padding
      child: Column(
        children: [
          // Modern search field with rounded corners and elevation
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _mainpageController.searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                hintText: 'What are you looking for?',
                prefixIcon: const Icon(Icons.search, color: Colors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0), // Reduced padding
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _mainpageController.searchController.clear();
                    _mainpageController.searchTerm.value = '';
                    _mainpageController.applyFilters();
                  },
                ),
              ),
              onSubmitted: (value) {
                _mainpageController.searchTerm.value = value;
                _mainpageController.applyFilters();
              },
            ),
          ),

          const SizedBox(height: 12.0), // Reduced spacing

          // Filter chips instead of dropdowns for better mobile UX
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Age Filter
                Obx(() => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: const Icon(Icons.expand_more,
                                color: Colors.purple),
                            borderRadius: BorderRadius.circular(12.0),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            hint: const Text('Age Range'),
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
                          ),
                        ),
                      ),
                    )),

                // Gender Filter
                Obx(() => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: const Icon(Icons.expand_more,
                                color: Colors.purple),
                            borderRadius: BorderRadius.circular(12.0),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            hint: const Text('Gender'),
                            value:
                                _mainpageController.selectedGender.value.isEmpty
                                    ? null
                                    : _mainpageController.selectedGender.value,
                            items:
                                ['male', 'female', 'both'].map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(
                                    gender.substring(0, 1).toUpperCase() +
                                        gender.substring(1)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _mainpageController.selectedGender.value = value!;
                              _mainpageController.applyFilters();
                            },
                          ),
                        ),
                      ),
                    )),

                // Categories Filter
                Obx(() {
                  // Create a list of categories including "All Categories"
                  List<Category> categoriesWithAll = [
                    Category(id: -1, name: 'All'),
                    ..._mainpageController.categories
                  ];

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          icon: const Icon(Icons.expand_more,
                              color: Colors.purple),
                          borderRadius: BorderRadius.circular(12.0),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          hint: const Text('Categories'),
                          value: _mainpageController
                                  .selectedCategory.value.isEmpty
                              ? null
                              : int.parse(
                                  _mainpageController.selectedCategory.value),
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
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 12.0), // Reduced spacing

          // Results counter and sort options
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0), // Reduced padding
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_mainpageController.items.length} Products',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )),
          ),

          // Product grid view
          Expanded(
            child: Obx(() {
              if (_mainpageController.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12), // Reduced spacing
                      const Text(
                        "No items found",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4), // Reduced spacing
                      const Text(
                        "Try adjusting your filters",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65, // Made more narrow to appear smaller
                  crossAxisSpacing: 6, // Reduced spacing further
                  mainAxisSpacing: 6, // Reduced spacing further
                ),
                itemCount: _mainpageController.items.length,
                itemBuilder: (context, index) {
                  Item item = _mainpageController.items[index];
                  TextEditingController quantityController =
                      TextEditingController();

                  return Card(
                    elevation: 1, // Reduced elevation further
                    shadowColor: Colors.grey.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Smaller radius
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Placeholder for product image
                        Container(
                          height: 90, // Further reduced height
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.toys,
                              size: 36, // Smaller icon
                              color: Colors.purple.shade300,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(
                              6.0), // Further reduced padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product name
                              Text(
                                item.name ?? 'No Name',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12, // Smaller font
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 2), // Reduced spacing

                              // Price with dollar sign
                              Text(
                                "\$${item.price}",
                                style: TextStyle(
                                  color: Colors.purple.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14, // Smaller font
                                ),
                              ),

                              const SizedBox(
                                  height: 1), // Further reduced spacing

                              // Availability indicator
                              Text(
                                "In stock: ${item.quantity}",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 9, // Smaller font
                                ),
                              ),

                              const SizedBox(height: 3), // Reduced spacing

                              // Row for quantity and add button
                              Row(
                                children: [
                                  // Quantity input field
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 28, // Smaller height
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(
                                            5.0), // Smaller radius
                                      ),
                                      child: TextField(
                                        controller: quantityController,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 11), // Smaller font
                                        decoration: const InputDecoration(
                                          hintText: "Qty",
                                          hintStyle: TextStyle(
                                              fontSize: 11), // Smaller font
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 2,
                                            vertical: 0,
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 3), // Small spacing

                                  // Add to cart button
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      height: 28, // Smaller height
                                      child: ElevatedButton(
                                        onPressed: () {
                                          String enteredQuantity =
                                              quantityController.text;

                                          if (enteredQuantity.isNotEmpty) {
                                            int quantity =
                                                int.parse(enteredQuantity);
                                            if (item.quantity == 0) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Out of stock",
                                                  ),
                                                ),
                                              );
                                            } else if (quantity > 0 &&
                                                quantity <= item.quantity!) {
                                              _cartController.addToCart(
                                                  item, quantity);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "${quantity}x ${item.name} added",
                                                  ),
                                                  backgroundColor:
                                                      Colors.purple,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Enter 1-${item.quantity}",
                                                  ),
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text("Enter quantity"),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.purple,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                5.0), // Smaller radius
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text(
                                          "Add",
                                          style: TextStyle(
                                              fontSize: 11), // Smaller font
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          // Pagination buttons with modern design
          Padding(
            padding: const EdgeInsets.only(top: 4.0), // Reduced padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: _mainpageController.previousPage,
                  icon: const Icon(Icons.arrow_back_ios,
                      size: 14), // Smaller icon
                  label: const Text("Prev",
                      style: TextStyle(fontSize: 12)), // Smaller text
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.purple,
                    side: const BorderSide(color: Colors.purple),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(6.0), // Smaller radius
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 0), // Reduced padding
                    minimumSize: const Size(80, 32), // Smaller button
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _mainpageController.nextPage,
                  icon: const Icon(Icons.arrow_forward_ios,
                      size: 14), // Smaller icon
                  label: const Text("Next",
                      style: TextStyle(fontSize: 12)), // Smaller text
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.purple,
                    side: const BorderSide(color: Colors.purple),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(6.0), // Smaller radius
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 0), // Reduced padding
                    minimumSize: const Size(80, 32), // Smaller button
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Epic Toy Store",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Get.to(() => CartView());
                },
              ),
              Obx(() => Positioned(
                    top: 8,
                    right: 8,
                    child: _cartController.cartItems.isEmpty
                        ? const SizedBox()
                        : Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              _cartController.cartItems.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  )),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Get.toNamed('/profile');
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: SafeArea(
          // Added SafeArea to prevent overflow
          child: _buildMainContent(),
        ),
      ),
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
              Get.offAllNamed('/contact'); // 🛒 Navigate to Contact
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
