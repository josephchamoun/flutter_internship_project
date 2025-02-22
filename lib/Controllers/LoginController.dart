import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Core/Network/DioClient.dart';
import '../Core/ShowSuccessDialog.dart';
import '../Models/User.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  late SharedPreferences prefs;
  @override
  void onInit() {
    super.onInit();
    _loadPrefs();
  }

  void _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      Get.offAllNamed('/mainpage');
    }
  }

  void submit() {
    String emailValue = email.text.trim();
    String passwordValue = password.text.trim();

    if (emailValue.isEmpty || !GetUtils.isEmail(emailValue)) {
      Get.snackbar("Error", "Please enter a valid email.");
    } else if (passwordValue.isEmpty) {
      Get.snackbar("Error", "Please enter your password.");
    } else {
      login();
    }
  }

  @override
  void onClose() {
    // Dispose controllers when no longer needed
    email.dispose();
    password.dispose();
    super.onClose();
  }

  void login() async {
    try {
      User user = User(
        email: email.text,
        password: password.text,
      );

      String requestBody = user.toJson();

      var post = await Dioclient()
          .getInstance()
          .post('/login/apilogin', data: requestBody);

      if (post.statusCode == 200) {
        if (post.data != null && post.data['success'] == true) {
          // Save token
          prefs.setString('token', post.data['token']);

          // Extract and save user ID properly
          int userId = post.data['user']['id']; // Get it as an integer
          prefs.setInt('user_id', userId); // Save it as an integer

          ShowSuccessDialog(
              Get.context!, "Success", "User Login Successfully", () {});

          Get.offAllNamed('/mainpage');
        } else {
          ShowSuccessDialog(Get.context!, "Failed", "User Login Failed", () {});
        }
      } else {
        ShowSuccessDialog(Get.context!, "Failed", "User Login Failed", () {});
      }
    } catch (e) {
      ShowSuccessDialog(Get.context!, "Error",
          "Something went wrong. Please try again.", () {});
    }
  }
}
