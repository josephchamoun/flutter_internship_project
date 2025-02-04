import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Core/Network/DioClient.dart';
import '../Core/ShowSuccessDialog.dart';
import '../Models/User.dart';
class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void submit() {
    String emailValue = email.text.trim();
    String passwordValue = password.text.trim();


    if (emailValue.isEmpty || !GetUtils.isEmail(emailValue)) {
      Get.snackbar("Error", "Please enter a valid email.");
    } else if (passwordValue.isEmpty) {
      Get.snackbar("Error", "Please enter your password.");
    }
    else {
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


  void login() async
  {
    User user = User(
      email: email.text,
      password: password.text,

    );
    String requestBody = user.toJson();

    var post = await Dioclient().getInstance().post('/login/apilogin', data: requestBody);


    if (post.statusCode == 200) {
      if (post.data['success']) {
        ShowSuccessDialog(
            Get.context!, "Success", "User Login Successfully", () {});
      }else{
        ShowSuccessDialog(Get.context!,"failed","User Login Failed",(){});
      }
    }
      else {
        ShowSuccessDialog(Get.context!, "Failed", " User Login Failed", () {});
      }
    }
  }

