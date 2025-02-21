import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Models/Item.dart';
import 'package:internship_mobile_project/Models/Category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internship_mobile_project/Models/myorders.dart';

class MyOrdersController extends GetxController {
    RxInt selectedIndex = 0.obs;
    var myorders = <MyOrders>[].obs;
    var isLoading = false.obs;
    var currentPage = 1.obs;
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
    } 
  }

  void fetchOrders() async {
    try {
      isLoading.value = true;
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/api/orders/myorders?page=${currentPage.value}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var ordersList = jsonData['data'] as List; // Extract the list of orders
        myorders.value = ordersList.map((myorder) => MyOrders.fromJson(myorder)).toList();
        print("Fetched ${myorders.length} myorders"); // Debug print
      } else {
        print('Failed to fetch my orders: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to fetch my orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

 

  void applyFilters() {
    currentPage.value = 1;
    fetchOrders();
  }

  void nextPage() {
    currentPage.value++;
    fetchOrders();
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchOrders();
    }
  }
}
