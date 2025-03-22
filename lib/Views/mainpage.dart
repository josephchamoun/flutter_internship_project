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

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Column(
        children: [
          // Enhanced search field with theme colors
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _mainpageController.searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                hintText: 'What are you looking for?',
                prefixIcon: Icon(Icons.search,
                    color: Theme.of(context).colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
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

          const SizedBox(height: 16.0),

          // Enhanced filter chips with theme colors
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Age Filter
                Obx(() => Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: Icon(Icons.expand_more,
                                color: Theme.of(context).colorScheme.primary),
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
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: Icon(Icons.expand_more,
                                color: Theme.of(context).colorScheme.primary),
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
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          icon: Icon(Icons.expand_more,
                              color: Theme.of(context).colorScheme.primary),
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

          const SizedBox(height: 16.0),

          // Results counter with theme colors
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_mainpageController.items.length} Products',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                )),
          ),

          // Enhanced product grid view
          Expanded(
            child: Obx(() {
              if (_mainpageController.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off,
                          size: 64,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.4)),
                      const SizedBox(height: 16),
                      Text(
                        "No items found",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Try adjusting your filters",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _mainpageController.items.length,
                itemBuilder: (context, index) {
                  Item item = _mainpageController.items[index];
                  TextEditingController quantityController =
                      TextEditingController();

                  return Card(
                    elevation: 2,
                    shadowColor: Theme.of(context).shadowColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product image container with gradient background
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.2),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.toys,
                              size: 42,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product name
                              Text(
                                item.name ?? 'No Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 4),

                              // Price with enhanced styling
                              Text(
                                "\$${item.price}",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 4),

                              // Availability indicator with theme colors
                              Row(
                                children: [
                                  Icon(
                                    Icons.inventory_2,
                                    size: 12,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "In stock: ${item.quantity}",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Row for quantity and add button
                              Row(
                                children: [
                                  // Quantity input field with theme styling
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: TextField(
                                        controller: quantityController,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 12),
                                        decoration: const InputDecoration(
                                          hintText: "Qty",
                                          hintStyle: TextStyle(fontSize: 12),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 0,
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 6),

                                  // Enhanced add to cart button
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      height: 32,
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
                                                SnackBar(
                                                  content: const Text(
                                                      "Out of stock"),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .error,
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
                                                      "${quantity}x ${item.name} added"),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Enter 1-${item.quantity}"),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    "Enter quantity"),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_shopping_cart,
                                                size: 12),
                                            const SizedBox(width: 2),
                                            const Text(
                                              "Add",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
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

          // Enhanced pagination buttons
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: _mainpageController.previousPage,
                  icon: const Icon(Icons.arrow_back_ios, size: 14),
                  label: const Text("Prev", style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    minimumSize: const Size(90, 36),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _mainpageController.nextPage,
                  icon: const Icon(Icons.arrow_forward_ios, size: 14),
                  label: const Text("Next", style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    minimumSize: const Size(90, 36),
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
        title: Text(
          "Epic Toy Store",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.onPrimary),
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
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              _cartController.cartItems.length.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onError,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  )),
            ],
          ),
          IconButton(
            icon: Icon(Icons.person,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              Get.toNamed('/profile');
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: _buildMainContent(context),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _mainpageController.selectedIndex.value,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/mainpage');
              break;
            case 1:
              Get.offAllNamed('/myorders');
              break;
            case 2:
              Get.offAllNamed('/contact');
              break;
            case 3:
              Get.offAllNamed('/about');
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
