import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Controllers/MainpageController.dart';
import 'package:internship_mobile_project/Models/Category.dart';
import 'package:internship_mobile_project/Models/Item.dart';

class Mainpage extends StatelessWidget {
  final MainpageController _mainpageController = Get.put(MainpageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("E-Commerce App")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _mainpageController.searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
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
                  return DropdownButton<String>(
                    hint: Text('Select Age'),
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
              Expanded(
                child: Obx(() {
                  return DropdownButton<String>(
                    hint: Text('Select Gender'),
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
              Expanded(
                child: Obx(() {
                  return DropdownButton<int>(
                    hint: Text('Select Category'),
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
          Expanded(
            child: Obx(() {
              if (_mainpageController.items.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: _mainpageController.items.length,
                itemBuilder: (context, index) {
                  Item item = _mainpageController.items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.description),
                    trailing: Text("\$${item.price}"),
                    leading:
                        (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                            ? Image.network(item.imageUrl!)
                            : Icon(Icons.image_not_supported),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
