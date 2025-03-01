import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Controllers/MyOrdersDetailsController.dart';
import 'package:internship_mobile_project/Models/OrderDetails.dart';

// ignore: must_be_immutable
class MyOrdersDetails extends StatelessWidget {
  MyOrdersDetails({Key? key}) : super(key: key);

  final MyOrdersDetailsController _controller =
      Get.put(MyOrdersDetailsController());
  final String? orderId = Get.parameters['orderId'];

  RxList<String> allquantities = <String>[].obs; // Reactive quantity list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        backgroundColor: Colors.teal.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed('/myorders'); // Go back to My Orders page
          },
        ),
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

          // Initialize `allquantities` when data is loaded
          if (allquantities.isEmpty) {
            allquantities.addAll(_controller.orderDetails.value!
                .map((order) => order.quantity.toString())
                .toList());
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: _controller.orderDetails.value!.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    OrderDetails order = _controller.orderDetails.value![index];

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
                                                  allquantities[index]) ??
                                              1;
                                          if (currentQuantity > 1) {
                                            allquantities[index] =
                                                (currentQuantity - 1)
                                                    .toString();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (value) {
                                            // Ensure quantity is never null or empty, set it to 1 if invalid
                                            if (value.isEmpty) {
                                              allquantities[index] = '1';
                                            } else {
                                              int newQuantity =
                                                  int.tryParse(value) ?? 1;
                                              allquantities[index] =
                                                  newQuantity.toString();
                                            }
                                          },
                                          controller: TextEditingController(
                                              text: allquantities[index]),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add,
                                            color: Colors.green),
                                        onPressed: () {
                                          int currentQuantity = int.tryParse(
                                                  allquantities[index]) ??
                                              1;
                                          allquantities[index] =
                                              (currentQuantity + 1).toString();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Obx(() => Text(
                                  "Total: \$${((order.item?.price ?? 0) * (int.tryParse(allquantities[index]) ?? 1)).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
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

                  if (orderId != null) {
                    // Collect updated order details with new quantities
                    List<OrderDetails> updatedOrderDetails = _controller
                        .orderDetails.value!
                        .asMap()
                        .entries
                        .map((entry) {
                      int idx = entry.key;
                      OrderDetails order = entry.value;
                      int updatedQuantity =
                          int.tryParse(allquantities[idx]) ?? order.quantity;

                      return OrderDetails(
                        id: order.id,
                        item: order.item,
                        quantity: updatedQuantity,
                      );
                    }).toList();

                    print("[DEBUG] Updated Quantities: $allquantities");
                    print(
                        "[DEBUG] Updated Order Details: $updatedOrderDetails");

                    // Update the order with the new order details
                    _controller.updateOrder(
                        int.parse(orderId!), updatedOrderDetails);

                    print(
                        "[DEBUG] Order updated with orderId: $orderId and updated order details: $updatedOrderDetails");
                  } else {
                    print("[ERROR] orderId is null, cannot update order.");
                  }
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
