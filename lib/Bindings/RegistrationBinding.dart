import 'package:internship_mobile_project/Controllers/RegistrationController.dart';
import 'package:get/get.dart';

class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegistrationController());
  }
}
