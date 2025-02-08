import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Models/Item.dart';
import 'package:internship_mobile_project/Models/Category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MainpageController extends GetxController {
  var items = <Item>[].obs;
  var categories = <Category>[].obs;
  var searchTerm = ''.obs;
  var selectedAge = ''.obs;
  var selectedGender = ''.obs;
  var selectedCategory = ''.obs;
  TextEditingController searchController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void onInit() {
    super.onInit();
    _loadPrefs();
  }

  void _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      Get.offAllNamed('/login');
    } else {
      fetchItems();
      fetchCategories();
    }
  }

  void fetchItems() async {
    try {
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse(
            'http://localhost:8000/api/dashboard?search=${searchTerm.value}&age=${selectedAge.value}&gender=${selectedGender.value}&category=${selectedCategory.value}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var itemsList = jsonData['data'] as List; // Extract the list of items
        items.value = itemsList.map((item) => Item.fromJson(item)).toList();
        print("Fetched ${items.length} items"); // Debug print
      } else {
        print('Failed to fetch items: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to fetch items: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'Exception: $e');
    }
  }

  void fetchCategories() async {
    try {
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/categories'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var categoriesList =
            jsonData['data'] as List; // Extract the list of categories
        categories.value = categoriesList
            .map((category) => Category.fromJson(category))
            .toList();
        print("Fetched ${categories.length} categories"); // Debug print
      } else {
        print('Failed to fetch categories: ${response.statusCode}');
        Get.snackbar(
            'Error', 'Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'Exception: $e');
    }
  }

  void applyFilters() {
    fetchItems();
  }
}
