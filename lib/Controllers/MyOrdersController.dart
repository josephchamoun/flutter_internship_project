import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internship_mobile_project/Models/Order.dart';

class MyOrdersController extends GetxController {
  RxInt selectedIndex = 0.obs;
  var myorders = <Order>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  late SharedPreferences prefs;

  final baseUrl = 'http://127.0.0.1:8000/api/orders/myorders';

  @override
  void onInit() {
    super.onInit();
    _loadPrefs().then((_) => fetchOrders());
  }

  Future<void> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      Get.offAllNamed('/login');
    }
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      prefs = await SharedPreferences.getInstance(); // Ensure prefs is loaded
      final token = prefs.getString('token');
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl?page=${currentPage.value}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var ordersList = jsonData['data'] as List;
        myorders.assignAll(
            ordersList.map((order) => Order.fromJson(order)).toList());
      } else {
        Get.snackbar(
            'Error', 'Failed to fetch my orders: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void nextPage() {
    if (!isLoading.value) {
      currentPage.value++;
      fetchOrders();
    }
  }

  void previousPage() {
    if (currentPage.value > 1 && !isLoading.value) {
      currentPage.value--;
      fetchOrders();
    }
  }
}
