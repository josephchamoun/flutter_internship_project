import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Models/Messages.dart';
import 'package:internship_mobile_project/Views/contact.dart' as contact_view;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Core/Network/DioClient.dart';
import '../Core/ShowSuccessDialog.dart';
import '../Models/User.dart';
import '../Models/Contact.dart';

class ContactController extends GetxController {
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();
  var isLoading = false.obs;
  var contact = <Contact>[].obs;
  final baseUrl = 'http://127.0.0.1:8000/api/contact/info';
  late SharedPreferences prefs;
  @override
  void onInit() {
    super.onInit();
    _loadPrefs();
  }

  void _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      Get.offAllNamed('/login');
    }
  }

  void fetchContacts() async {
    try {
      isLoading.value = true;
      prefs = await SharedPreferences.getInstance(); // Ensure prefs is loaded
      final token = prefs.getString('token');
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var contactlist = jsonData['data'] as List;
        contact.value =
            contactlist.map((category) => Contact.fromJson(category)).toList();
      } else {
        Get.snackbar(
            'Error', 'Failed to fetch contact: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void addMessage() async {
    try {
      final ContactController _contactController =
          Get.find<ContactController>();

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

      // Create order object
      Messages messages = Messages(
        user: userId, // Use the retrieved user ID
        subject: _contactController.subject.text,
        message: _contactController.message.text,
      );

      // Convert to JSON
      String requestBody = json.encode(messages.toJson());

      var response = await Dioclient().getInstance().post(
            '/messages/postmessage',
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
          Get.offAllNamed('/contact');
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
}
