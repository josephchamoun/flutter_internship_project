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
          int userId = post.data['user']['id']; // Get it as an integer
          String userName = post.data['user']['name']; // Get the user's name
          String userEmail = post.data['user']['email']; // Get the user's email
          String userAddress =
              post.data['user']['address']; // Get the user's address

          prefs.setInt('user_id', userId); // Save user ID as an integer
          prefs.setString('user_name', userName); // Save user name as a string
          prefs.setString('user_email', userEmail); // Save user email as
          prefs.setString(
              'user_address', userAddress); // Save user address as a string

          ShowSuccessDialog(
              Get.context!, "Success", "User Login Successfully", () {});

          Get.offAllNamed('/mainpage');
        } else {
          ShowSuccessDialog(Get.context!, "Failed", "User Login Failed", () {});
        }
      } else {
        ShowSuccessDialog(
            Get.context!, "Failed", "Wrong email or password", () {});
      }
    } catch (e) {
      ShowSuccessDialog(
          Get.context!, "Error", "Wrong email or password", () {});
    }
  }
}
