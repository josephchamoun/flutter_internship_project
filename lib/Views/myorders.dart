import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:internship_mobile_project/Controllers/CartController.dart';
import 'package:internship_mobile_project/Controllers/MyOrdersController.dart';
import 'package:internship_mobile_project/Models/Category.dart';
import 'package:internship_mobile_project/Models/Order.dart';
import 'package:internship_mobile_project/Models/User.dart';
import 'package:internship_mobile_project/Views/cart.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final MyOrdersController _myordersController =
        Get.put(MyOrdersController());

    return Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
          backgroundColor: Colors.teal,
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
                    return const Center(child: Text("No orders found."));
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
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            "#" + "${myorders.id.toString()}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(myorders.user),
                              SizedBox(height: 8),
                              Text("${myorders.total_amount.toString()}" +
                                  " " +
                                  "USD"),
                              SizedBox(height: 8),
                              Text(myorders.created_at),
                              ElevatedButton(
                                onPressed: () {
                                  print(
                                      "[DEBUG] Navigating to order details with orderId: ${myorders.id}");
                                  Get.toNamed(
                                      '/myordersdetails/${myorders.id}');
                                },
                                child: Text("View Details"),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 36),
                                ),
                              )
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
                    child: const Text("Previous"),
                  ),
                  ElevatedButton(
                    onPressed: _myordersController.nextPage,
                    child: const Text("Next"),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
