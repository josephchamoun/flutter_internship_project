import 'package:internship_mobile_project/Controllers/MyOrdersDetailsController.dart';
import 'package:get/get.dart';

class MyOrdersDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyOrdersDetailsController());
  }
}
