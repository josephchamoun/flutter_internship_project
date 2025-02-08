import 'package:internship_mobile_project/Controllers/MainpageController.dart';
import 'package:get/get.dart';

class MainpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainpageController());
  }
}

