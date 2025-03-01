import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internship_mobile_project/Core/Network/DioClient.dart';
import 'package:internship_mobile_project/Core/ShowSuccessDialog.dart';
import 'package:internship_mobile_project/Models/Item.dart';
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
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
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

  void updateOrder(int orderid, List<OrderDetails> itemsupdated) async {
    final token = prefs.getString('token');
    if (token == null) {
      Get.snackbar("Error", "Token not found. Please log in again.");
      Get.offAllNamed('/login');
      return;
    }

    List<OrderDetails> finalitems = itemsupdated.map((orderdet) {
      return OrderDetails(
        item: orderdet.item,
        quantity: orderdet.quantity,
      );
    }).toList();

    try {
      Map<String, dynamic> requestBody = {
        'items': finalitems.map((orderdet) {
          return {
            'id': orderdet.item?.id, // Get item ID instead of orderDetails ID
            'quantity': orderdet.quantity,
          };
        }).toList()
      };

      var update = await Dioclient().getInstance().put(
            '/orders/update/$orderid',
            data: requestBody,
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          );

      if (update.statusCode == 200 && update.data != null) {
        if (update.data['message'] == "Order updated successfully") {
          ShowSuccessDialog(
              Get.context!, "Success", "Order Updated Successfully", () {
            // Refresh the orders list after update
          });
        } else {
          ShowSuccessDialog(
              Get.context!, "Failed", "Order Failed to be updated", () {});
        }
      } else {
        ShowSuccessDialog(Get.context!, "Failed", "Order update Failed", () {});
      }
    } catch (e) {
      ShowSuccessDialog(Get.context!, "Error",
          "Something went wrong. Please try again.", () {});
    }
  }

/*
  void deleteOrderDetails(int orderId) async {
    final token = prefs.getString('token');
    if (token == null) {
      Get.snackbar("Error", "Token not found. Please log in again.");
      Get.offAllNamed('/login');
      return;
    }

    try {
      var response = await Dioclient().getInstance().delete(
            '/orders/delete/$orderId',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['message'] == "Order deleted successfully") {
          ShowSuccessDialog(
              Get.context!, "Success", "Order Deleted Successfully", () {
            // Refresh the orders list after delete
          });
        } else {
          ShowSuccessDialog(
              Get.context!, "Failed", "Order Failed to be deleted", () {});
        }
      } else {
        ShowSuccessDialog(Get.context!, "Failed", "Order delete Failed", () {});
      }
    } catch (e) {
      ShowSuccessDialog(Get.context!, "Error",
          "Something went wrong. Please try again.", () {});
    }
  }*/
}
