import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Controllers/MyOrdersDetailsController.dart';
import 'package:internship_mobile_project/Models/Item.dart';
import 'package:internship_mobile_project/Models/Order.dart';
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
        backgroundColor: Colors.teal.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.orderDetails.value == null ||
              _controller.orderDetails.value!.isEmpty) {
            return const Center(child: Text("No order details found."));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: _controller.orderDetails.value!.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    OrderDetails order = _controller.orderDetails.value![index];

                    TextEditingController quantityController =
                        TextEditingController(text: order.quantity.toString());

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order.item?.name ?? 'Unknown Item',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove,
                                            color: Colors.redAccent),
                                        onPressed: () {
                                          int currentQuantity = int.tryParse(
                                                  quantityController.text) ??
                                              1;
                                          if (currentQuantity > 1) {
                                            quantityController.text =
                                                (currentQuantity - 1)
                                                    .toString();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 40,
                                        child: TextField(
                                          controller: quantityController,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add,
                                            color: Colors.green),
                                        onPressed: () {
                                          int currentQuantity = int.tryParse(
                                                  quantityController.text) ??
                                              1;
                                          quantityController.text =
                                              (currentQuantity + 1).toString();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Total: \$${(order.quantity).toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                print(
                                    "[DEBUG] Delete clicked for: ${order.item}");
                                // Implement delete functionality
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  print("[DEBUG] Save button clicked");
                  // Implement save functionality
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Colors.teal.shade700,
                ),
                child: const Text(
                  "Save Order Details",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
