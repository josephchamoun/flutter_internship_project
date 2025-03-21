import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internship_mobile_project/Controllers/CartController.dart';
import 'package:internship_mobile_project/Core/Network/DioClient.dart';
import 'package:internship_mobile_project/Core/ShowSuccessDialog.dart';
import 'package:internship_mobile_project/Models/Item.dart';
import 'package:internship_mobile_project/Models/OrderDetails.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internship_mobile_project/Models/Order.dart';

class MyOrdersController extends GetxController {
  TextEditingController total_amount = TextEditingController();
  TextEditingController user = TextEditingController();
  RxInt selectedIndex = 0.obs;
  var myorders = <Order>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  late SharedPreferences prefs;

  final baseUrl =
      'https://d499-94-72-152-229.ngrok-free.app/api/orders/myorders';

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
      if (myorders.isEmpty) {
        return;
      }
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

  void addOrder(List<Item> cartItems) async {
    try {
      final CartController _cartController = Get.find<CartController>();
      double total_amount = _cartController.totalAmount.value;

      prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id'); // Retrieve user ID

      if (userId == null) {
        Get.snackbar("Error", "User ID not found. Please log in again.");
        Get.offAllNamed('/login');
        return;
      }
      final token = prefs.getString('token');
      if (token == null) {
        Get.snackbar("Error", "Token not found. Please log in again.");
        Get.offAllNamed('/login');
        return;
      }

      // Convert cart items to order details
      List<Item> orderDetailsList = cartItems.map((item) {
        return Item(
          id: item.id,
          price: item.price,
          name: item.name,
          quantity: item.quantityInCart ?? 1,
        );
      }).toList();

      // Create order object
      Order order = Order(
        user_id: userId, // Use the retrieved user ID
        total_amount: total_amount,
        status: "pending",
        cart: orderDetailsList,
      );

      // Convert to JSON
      String requestBody = json.encode(order.toJson());

      var response = await Dioclient().getInstance().post(
            '/orders/addorder',
            data: requestBody,
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'Accept': 'application/json'
              },
            ),
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['success'] == true) {
          ShowSuccessDialog(
              Get.context!, "Success", "Order Placed Successfully", () {});
          Get.offAllNamed('/myorders');
        } else {
          ShowSuccessDialog(
              Get.context!, "Failed", "Order Placement Failed", () {});
        }
      } else {
        ShowSuccessDialog(
            Get.context!, "Failed", "Order Placement Failed", () {});
      }
    } catch (e) {
      ShowSuccessDialog(Get.context!, "Error",
          "Something went wrong. Please try again.", () {});
    }
  }

  void deleteOrder(int orderid) async {
    final token = prefs.getString('token');
    if (token == null) {
      Get.snackbar("Error", "Token not found. Please log in again.");
      Get.offAllNamed('/login');
      return;
    }

    try {
      var delete = await Dioclient().getInstance().delete(
            '/orders/delete/$orderid',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          );

      if (delete.statusCode == 200 && delete.data != null) {
        if (delete.data['success'] == true) {
          ShowSuccessDialog(
              Get.context!, "Success", "Order Deleted Successfully", () {
            // Refresh the orders list after deletion
            fetchOrders();
          });
        } else {
          ShowSuccessDialog(
              Get.context!, "Failed", "Order Failed to be deleted", () {});
        }
      } else {
        ShowSuccessDialog(Get.context!, "Failed", "Order Delete Failed", () {});
      }
    } catch (e) {
      ShowSuccessDialog(Get.context!, "Error",
          "Something went wrong. Please try again.", () {});
    }
  }
}
