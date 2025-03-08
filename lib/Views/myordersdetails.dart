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
  final String? orderStatus =
      Get.parameters['orderStatus']; // ✅ Get status from MyOrders page

  RxList<String> allquantities = <String>[].obs; // Reactive quantity list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.purple.shade600,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          onPressed: () {
            Get.offAllNamed('/myorders'); // Go back to My Orders page
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: orderStatus == "shipped"
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_shipping_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Shipped",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.pending_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Pending",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.withOpacity(0.05), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (_controller.isLoading.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.purple.shade600,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Loading order details...",
                      style: TextStyle(
                        color: Colors.purple.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (_controller.orderDetails.value == null ||
                _controller.orderDetails.value!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No order details found",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This order appears to be empty",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Initialize allquantities when data is loaded
            if (allquantities.isEmpty) {
              allquantities.addAll(_controller.orderDetails.value!
                  .map((order) => order.quantity.toString())
                  .toList());
            }

            // Calculate total order cost
            double totalOrderCost = 0;
            for (int i = 0; i < _controller.orderDetails.value!.length; i++) {
              OrderDetails order = _controller.orderDetails.value![i];
              totalOrderCost += (order.item?.price ?? 0) *
                  (int.tryParse(allquantities[i]) ?? 1);
            }

            return Column(
              children: [
                // Order summary card
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order #$orderId",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${_controller.orderDetails.value!.length} Items",
                              style: TextStyle(
                                color: Colors.purple.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount:",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            "\$${totalOrderCost.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Items list header
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    "Order Items",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: _controller.orderDetails.value!.length,
                    itemBuilder: (context, index) {
                      OrderDetails order =
                          _controller.orderDetails.value![index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product image placeholder
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Colors.purple.shade600,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Product details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.item?.name ?? 'Unknown Item',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Unit Price: \$${(order.item?.price ?? 0).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        // Price calculation
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Quantity controls
                                            Expanded(
                                              child: orderStatus == "shipped"
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 12,
                                                        vertical: 8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade100,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            "Quantity:",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.grey
                                                                  .shade700,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            allquantities[
                                                                index],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey.shade100,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  int currentQuantity =
                                                                      int.tryParse(
                                                                              allquantities[index]) ??
                                                                          1;
                                                                  if (currentQuantity >
                                                                      1) {
                                                                    allquantities[
                                                                        index] = (currentQuantity -
                                                                            1)
                                                                        .toString();
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 36,
                                                                  height: 36,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300,
                                                                    ),
                                                                  ),
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: Colors
                                                                        .red
                                                                        .shade400,
                                                                    size: 16,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 50,
                                                                height: 36,
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child:
                                                                      TextField(
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      contentPadding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                    ),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    onChanged:
                                                                        (value) {
                                                                      if (value
                                                                          .isEmpty) {
                                                                        allquantities[index] =
                                                                            '1';
                                                                      } else {
                                                                        int newQuantity =
                                                                            int.tryParse(value) ??
                                                                                1;
                                                                        allquantities[index] =
                                                                            newQuantity.toString();
                                                                      }
                                                                    },
                                                                    controller:
                                                                        TextEditingController(
                                                                            text:
                                                                                allquantities[index]),
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  int currentQuantity =
                                                                      int.tryParse(
                                                                              allquantities[index]) ??
                                                                          1;
                                                                  allquantities[
                                                                          index] =
                                                                      (currentQuantity +
                                                                              1)
                                                                          .toString();
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 36,
                                                                  height: 36,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300,
                                                                    ),
                                                                  ),
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .green
                                                                        .shade600,
                                                                    size: 16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),

                                            // Item total price
                                            Obx(() => Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.purple.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    "\$${((order.item?.price ?? 0) * (int.tryParse(allquantities[index]) ?? 1)).toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                      color: Colors
                                                          .purple.shade700,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // Delete button (only for non-shipped orders)
                              if (orderStatus != "shipped")
                                Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        print(
                                            "[DEBUG] Delete clicked for: ${order.item}");
                                        if (_controller
                                                .orderDetails.value!.length ==
                                            1) {
                                          Get.snackbar(
                                            "Cannot Delete",
                                            "At least one item is required in the order.",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor:
                                                Colors.red.shade400,
                                            colorText: Colors.white,
                                            margin: const EdgeInsets.all(16),
                                            borderRadius: 8,
                                            icon: const Icon(
                                              Icons.error_outline,
                                              color: Colors.white,
                                            ),
                                          );
                                          return;
                                        }
                                        _controller.orderDetails.value!
                                            .removeAt(index);
                                        allquantities.removeAt(index);

                                        // 🔥 Force UI refresh
                                        _controller.orderDetails.refresh();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              color: Colors.red.shade400,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Remove Item",
                                              style: TextStyle(
                                                color: Colors.red.shade400,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                if (orderStatus != "shipped")
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
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
                                int.tryParse(allquantities[idx]) ??
                                    order.quantity;

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
                          print(
                              "[ERROR] orderId is null, cannot update order.");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.save_outlined, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            "Save Changes",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
