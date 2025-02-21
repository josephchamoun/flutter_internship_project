import 'package:internship_mobile_project/Controllers/MyOrdersController.dart';
import 'package:get/get.dart';

class MyOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyOrdersController());
  }
}
