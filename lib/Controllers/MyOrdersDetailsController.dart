import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internship_mobile_project/Models/OrderDetails.dart';

class MyOrdersDetailsController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<List<OrderDetails>> orderDetails =
      Rxn<List<OrderDetails>>(); // Nullable observable list
  late SharedPreferences prefs;
  String baseUrl = '';

  @override
  void onInit() {
    super.onInit();
    print("[DEBUG] MyOrdersDetailsController initialized.");
    _loadPrefs(); // Load preferences before making API call
  }

  Future<void> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    print("[DEBUG] Preferences loaded.");

    String? token = prefs.getString('token');
    if (token == null) {
      print("[ERROR] No token found. Redirecting to login.");
      Get.snackbar("Error", "Session expired. Please log in again.");
      Get.offAllNamed('/login');
    } else {
      print("[DEBUG] Token found. Fetching order details.");
      fetchOrderDetails();
    }
  }

  Future<void> fetchOrderDetails() async {
    try {
      isLoading.value = true;
      final token = prefs.getString('token');
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      // Fetch the orderId from the route parameters
      String? orderId = Get.parameters['orderId'];

      if (orderId == null || orderId.isEmpty) {
        Get.snackbar('Error', 'Order ID is missing');
        return;
      }

      print("[DEBUG] Fetching order details for orderId: $orderId");

      baseUrl = 'http://127.0.0.1:8000/api/orders/myorder/details/$orderId';

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var ordersList = (jsonData['data'] as List)
            .map((order) => OrderDetails.fromJson(order))
            .toList();
        orderDetails.value = ordersList;
      } else {
        Get.snackbar(
            'Error', 'Failed to fetch order details: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
