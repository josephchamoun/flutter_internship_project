import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/Messages.dart';
import '../Models/Contact.dart';
import '../Core/Network/DioClient.dart';
import '../Core/ShowSuccessDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ContactController extends GetxController {
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();

  var isLoading = false.obs;
  var contact = Rxn<ContactModel>();
  var hasError = false.obs;
  var errorMessage = ''.obs;

  final baseUrl = 'http://127.0.0.1:8000/api/contact/info';
  late SharedPreferences prefs;
  bool _prefsInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  @override
  void onClose() {
    // Clean up controllers
    subject.dispose();
    message.dispose();
    super.onClose();
  }

  Future<void> _initPrefs() async {
    try {
      prefs = await SharedPreferences.getInstance();
      _prefsInitialized = true;

      // Check token on init
      final token = prefs.getString('token');
      if (token == null) {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print("Error initializing preferences: $e");
      hasError.value = true;
      errorMessage.value = "Failed to initialize app data";
    }
  }

  Future<void> fetchContacts() async {
    if (isLoading.value) return; // Prevent multiple concurrent calls

    try {
      // Ensure prefs are initialized
      if (!_prefsInitialized) {
        await _initPrefs();
      }

      isLoading.value = true;
      hasError.value = false;

      final token = prefs.getString('token');
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      // Use a better timeout
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("Connection timed out");
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey('contact')) {
          contact.value = ContactModel.fromJson(jsonData['contact']);
        } else {
          throw Exception("Invalid response format: 'contact' field missing");
        }
      } else {
        throw Exception(
            "Server returned ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Failed to load contact info: $e";
      print("Error in fetchContacts: $e");
      Get.snackbar(
        'Error',
        'Could not load contact information. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMessage() async {
    if (isLoading.value) return; // Prevent multiple concurrent calls

    try {
      isLoading.value = true;

      // Ensure prefs are initialized
      if (!_prefsInitialized) {
        await _initPrefs();
      }

      final token = prefs.getString('token');
      final userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        Get.snackbar(
          "Session Expired",
          "Please log in again to continue",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed('/login');
        return;
      }

      // Create message object
      final messageData = Messages(
        user: userId,
        subject: subject.text.trim(),
        message: message.text.trim(),
      );

      // Send the request
      final response = await Dioclient()
          .getInstance()
          .post(
            '/messages/postmessage',
            data: json.encode(messageData.toJson()),
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Clear the form on success
        subject.clear();
        message.clear();

        ShowSuccessDialog(
          Get.context!,
          "Success",
          "Your message has been sent successfully",
          () {
            // Optional: Refresh the page or perform other actions
          },
        );
      } else {
        throw Exception("Server returned ${response.statusCode}");
      }
    } catch (e) {
      print("Error in addMessage: $e");
      ShowSuccessDialog(
        Get.context!,
        "Error",
        "Failed to send message. Please try again later.",
        () {},
      );
    } finally {
      isLoading.value = false;
    }
  }
}

// Custom exception for timeouts
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}
