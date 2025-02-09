import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Controllers/MainpageController.dart';
import 'package:internship_mobile_project/Models/Category.dart';
import 'package:internship_mobile_project/Models/Item.dart';
import '../components/custom_bottom_navbar.dart';
import 'myorders.dart';
import 'contact.dart';
import 'about.dart';

class Mainpage extends StatelessWidget {
  final MainpageController _mainpageController = Get.put(MainpageController());

  // Your original content extracted to a widget
  // ...existing code...

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
                    items: ['0-3', '3-6', '6-9', '9-12', '13-17', '18+']
                        .map((String age) {
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
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Select Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    value: _mainpageController.selectedCategory.value.isEmpty
                        ? null
                        : int.parse(_mainpageController.selectedCategory.value),
                    items:
                        _mainpageController.categories.map((Category category) {
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
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: _mainpageController.items.length,
                itemBuilder: (context, index) {
                  Item item = _mainpageController.items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(item.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(item.description),
                      trailing: Text("\$${item.price}",

                          // ignore: prefer_const_constructors
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                      leading:
                          (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(item.imageUrl!,
                                      width: 50, height: 50, fit: BoxFit.cover),
                                )
                              : const Icon(Icons.image_not_supported, size: 50),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

// ...existing code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Epic Toy Store"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the shopping cart view
              Get.to(() => AboutView());
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to the profile view
              Get.to(() => AboutView());
            },
          ),
        ],
      ),
      body: Obx(() {
        switch (_mainpageController.selectedIndex.value) {
          case 0:
            return _buildMainContent(); // Original functionality
          case 1:
            return const MyOrdersView();
          case 2:
            return const ContactView();
          case 3:
            return const AboutView();
          default:
            return _buildMainContent();
        }
      }),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _mainpageController.selectedIndex.value,
        onTap: (index) => _mainpageController.selectedIndex.value = index,
      ),
    );
  }
}
