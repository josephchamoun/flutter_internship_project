import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Controllers/MyOrdersController.dart';
import 'package:internship_mobile_project/Models/Order.dart';
import 'package:internship_mobile_project/Routes/AppRoute.dart';
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
        title: const Text(
          'My Orders',
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
            Get.offAllNamed('/mainpage'); // Go back to Main Page properly
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
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
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        color: Colors.purple.shade700, size: 24),
                    const SizedBox(width: 12),
                    Obx(() => Text(
                          "${_myordersController.myorders.length} Orders",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.purple.shade700,
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: Obx(() {
                  if (_myordersController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.purple.shade600,
                        strokeWidth: 3,
                      ),
                    );
                  }
                  if (_myordersController.myorders.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "No orders found",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Start shopping to see your orders here",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ));
                  }
                  return ListView.builder(
                    itemCount: _myordersController.myorders.length,
                    itemBuilder: (context, index) {
                      Order myorders = _myordersController.myorders[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                print(
                                    "[DEBUG] Navigating to order details with orderId: ${myorders.id}");
                                Get.toNamed(AppRoute.myordersdetails,
                                    parameters: {
                                      'orderId': myorders.id.toString(),
                                      'orderStatus': myorders.status.toString()
                                    });
                              },
                              splashColor: Colors.purple.withOpacity(0.1),
                              highlightColor: Colors.purple.withOpacity(0.05),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.purple
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.receipt_long_outlined,
                                                color: Colors.purple.shade600,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              "Order #${myorders.id}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        myorders.status == "shipped"
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.purple
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.purple
                                                        .withOpacity(0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .local_shipping_outlined,
                                                      size: 14,
                                                      color: Colors
                                                          .purple.shade700,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "Shipped",
                                                      style: TextStyle(
                                                        color: Colors
                                                            .purple.shade700,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red.shade400,
                                                ),
                                                onPressed: () {
                                                  Get.defaultDialog(
                                                    title: "Confirm Deletion",
                                                    titleStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                    middleText:
                                                        "Are you sure you want to delete this order?",
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    radius: 12,
                                                    titlePadding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    textConfirm: "Delete",
                                                    textCancel: "Cancel",
                                                    confirmTextColor:
                                                        Colors.white,
                                                    buttonColor: Colors.red,
                                                    cancelTextColor:
                                                        Colors.grey,
                                                    barrierDismissible: false,
                                                    onConfirm: () {
                                                      print(
                                                          "[DEBUG] Deleting order: ${myorders.id}");
                                                      _myordersController
                                                          .deleteOrder(
                                                              myorders.id!);
                                                      Get.back(); // Close the dialog
                                                    },
                                                  );
                                                },
                                              ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Customer",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              myorders.user ?? "Unknown User",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text(
                                              "Amount",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "\$${myorders.total_amount.toString()}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.purple.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today_outlined,
                                              size: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              myorders.updated_at ?? "No Date",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.purple.shade600,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.remove_red_eye_outlined,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "View Details",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _myordersController.previousPage,
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      label: const Text("Previous"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _myordersController.nextPage,
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      label: const Text("Next"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
