import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internship_mobile_project/Models/OrderDetails.dart';

class MyOrdersDetailsController extends GetxController {
  RxInt selectedIndex = 0.obs;
  var myorders = <OrderDetails>[].obs;
  var isLoading = false.obs;

  late SharedPreferences prefs;

  // Remove baseUrl initialization here
  String baseUrl = '';

  @override
  void onInit() {
    super.onInit();
    _loadPrefs(); // Load preferences before making API call
  }

  Future<void> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      Get.offAllNamed('/login');
    } else {
      // If token exists, fetch orders
      fetchOrders();
    }
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final token = prefs.getString('token');
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      // Dynamically create the URL here
      String orderId = Get.parameters['orderId'] ?? '';
      baseUrl = 'http://127.0.0.1:8000/api/orders/myorder/details/$orderId';

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var ordersList = jsonData['data'] as List;
        myorders.assignAll(
            ordersList.map((order) => OrderDetails.fromJson(order)).toList());
      } else {
        Get.snackbar('Error',
            'Failed to fetch my order details: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
