import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Controllers/MyOrdersController.dart';
import 'package:internship_mobile_project/Models/Order.dart';
import 'package:internship_mobile_project/Views/mainpage.dart';
import 'package:internship_mobile_project/Controllers/MainpageController.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final MyOrdersController _myordersController =
        Get.put(MyOrdersController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed('/mainpage'); // Go back to Main Page properly
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Expanded(
              child: Obx(() {
                if (_myordersController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_myordersController.myorders.isEmpty) {
                  return const Center(
                      child: Text("No orders found.",
                          style: TextStyle(fontSize: 16)));
                }
                return ListView.builder(
                  itemCount: _myordersController.myorders.length,
                  itemBuilder: (context, index) {
                    Order myorders = _myordersController.myorders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "#${myorders.id}", //l order id bado t8yir la 3ada l orders li user 3emelon
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: "Confirm Deletion",
                                      middleText:
                                          "Are you sure you want to delete this order?",
                                      textConfirm: "Yes",
                                      textCancel: "No",
                                      confirmTextColor: Colors.white,
                                      buttonColor: Colors.red,
                                      onConfirm: () {
                                        print(
                                            "[DEBUG] Deleting order: ${myorders.id}");
                                        _myordersController
                                            .deleteOrder(myorders.id!);
                                        Get.back(); // Close the dialog
                                      },
                                      onCancel: () {
                                        print("[DEBUG] Deletion cancelled.");
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              myorders.user ?? "Unknown User",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${myorders.total_amount.toString()} USD",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              myorders.updated_at ?? "No Available Date",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                print(
                                    "[DEBUG] Navigating to order details with orderId: ${myorders.id}");
                                Get.toNamed('/myordersdetails/${myorders.id}');
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.teal,
                              ),
                              child: const Text("View Details",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _myordersController.previousPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text("Previous",
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: _myordersController.nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child:
                      const Text("Next", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
