import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Controllers/MyOrdersDetailsController.dart';
import 'package:internship_mobile_project/Models/OrderDetails.dart';

class MyOrdersDetails extends StatelessWidget {
  MyOrdersDetails({Key? key}) : super(key: key);

  final MyOrdersDetailsController _controller =
      Get.put(MyOrdersDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          print("[DEBUG] UI updated - Checking loading state...");

          if (_controller.isLoading.value) {
            print("[DEBUG] Loading indicator shown.");
            return const Center(child: CircularProgressIndicator());
          }

          print("[DEBUG] Checking if order details exist...");
          if (_controller.orderDetails.value == null ||
              _controller.orderDetails.value!.isEmpty) {
            print("[DEBUG] No order details found.");
            return const Center(child: Text("No order details found."));
          }

          print("[DEBUG] Rendering order details list...");
          return ListView.separated(
            itemCount: _controller.orderDetails.value!.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              OrderDetails order = _controller.orderDetails.value![index];

              print(
                  "[DEBUG] Displaying item: ${order.item}, Quantity: ${order.quantity}");

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(order.item,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantity: ${order.quantity}"),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          print(
                              "[DEBUG] Delete button clicked for: ${order.item}");
                          // Implement delete functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 36),
                        ),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
