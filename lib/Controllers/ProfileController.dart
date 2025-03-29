import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:internship_mobile_project/Core/Network/DioClient.dart';
import 'package:internship_mobile_project/Core/ShowSuccessDialog.dart';
import 'package:internship_mobile_project/Models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController oldpassword = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password_confirmation = TextEditingController();

  late SharedPreferences prefs;

  @override
  void onInit() {
    super.onInit();
    _loadPrefs(); // Load preferences before making API call
    _loadProfileData();
  }

  void logout() async {
    prefs.remove('token');
    Get.offAllNamed('/login');
  }

  Future<void> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      Get.offAllNamed('/login');
    }
  }

  void _loadProfileData() async {
    prefs = await SharedPreferences.getInstance();
    name.text = prefs.getString('user_name') ?? '';
    email.text = prefs.getString('user_email') ?? '';
    address.text = prefs.getString('user_address') ?? '';
  }

  void updateProfile() async {
    try {
      final token = prefs.getString('token');
      if (token == null) {
        Get.snackbar("Error", "Token not found. Please log in again.");
        Get.offAllNamed('/login');
        return;
      }

      User user = User(
        name: name.text,
        email: email.text,
        address: address.text,
      );

      String requestBody = user.toJson();

      var update = await Dioclient().getInstance().put('/person/update',
          data: requestBody,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));

      if (update.statusCode == 200 &&
          update.data != null &&
          update.data['message'] == "Success") {
        ShowSuccessDialog(
            Get.context!, "Success", "Profile Updated Successfully", () {});
        // Update the shared preferences with new data
        prefs.setString('user_name', name.text);
        prefs.setString('user_email', email.text);
        prefs.setString('user_address', address.text);
      } else {
        ShowSuccessDialog(Get.context!, "Error",
            update.data?['message'] ?? "Profile Update Failed", () {});
      }
    } catch (e) {
      // Catch any exceptions and display a failure message
      ShowSuccessDialog(Get.context!, "Error",
          "Something went wrong. Please try again.", () {});
    }
  }

  void updatePassword() async {
    try {
      final token = prefs.getString('token');
      if (token == null) {
        Get.snackbar("Error", "Token not found. Please log in again.");
        Get.offAllNamed('/login');
        return;
      }

      // Manually creating the JSON request with renamed keys
      Map<String, dynamic> requestBody = {
        'oldpassword': oldpassword.text,
        'newpassword':
            password.text, // Changed from 'password' to 'newpassword'
        'newpassword_confirmation': password_confirmation
            .text, // Changed from 'password_confirmation' to 'newpassword_confirmation'
      };

      var update = await Dioclient().getInstance().put('/person/updatepassword',
          data: requestBody,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));

      if (update.statusCode == 200 &&
          update.data != null &&
          update.data['message'] == "Success") {
        ShowSuccessDialog(
            Get.context!, "Success", "Password Updated Successfully", () {});
      } else {
        ShowSuccessDialog(Get.context!, "Error",
            update.data?['message'] ?? "Password Update Failed", () {});
      }
    } catch (e) {
      // Catch any exceptions and display a failure message
      ShowSuccessDialog(Get.context!, "Error",
          "Something went wrong. Please try again.", () {});
    }
  }

  void deleteUser() async {
    final token = prefs.getString('token');
    if (token == null) {
      Get.snackbar("Error", "Token not found. Please log in again.");
      Get.offAllNamed('/login');
      return;
    }

    try {
      var delete = await Dioclient().getInstance().delete(
            '/person/delete',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          );

      if (delete.statusCode == 200 && delete.data != null) {
        if (delete.data['message'] == "User deleted successfully") {
          ShowSuccessDialog(
              Get.context!, "Success", "Order Deleted Successfully", () {
            prefs.remove('token');

            Get.offAllNamed('/login');
          });
        } else {
          ShowSuccessDialog(
              Get.context!, "Failed", "User Failed to be deleted", () {});
        }
      } else {
        ShowSuccessDialog(Get.context!, "Failed", "User Delete Failed", () {});
      }
    } catch (e) {
      ShowSuccessDialog(Get.context!, "Error",
          "Something went wrong. Please try again.", () {});
    }
  }

  @override
  void onClose() {
    // Dispose controllers when no longer needed
    name.dispose();
    email.dispose();
    oldpassword.dispose();
    password.dispose();
    password_confirmation.dispose();
    super.onClose();
  }
}
