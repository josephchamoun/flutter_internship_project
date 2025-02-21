import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Controllers/CartController.dart';
import 'package:internship_mobile_project/Controllers/MainpageController.dart';
import 'package:internship_mobile_project/Models/Category.dart';
import 'package:internship_mobile_project/Models/Item.dart';
import 'package:internship_mobile_project/Models/OrderDetails.dart';
import 'package:internship_mobile_project/Views/profile.dart';
import '../components/custom_bottom_navbar.dart';
import 'cart.dart';
import 'myorders.dart';
import 'contact.dart';
import 'about.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Add this import
import 'package:internship_mobile_project/Controllers/MyOrdersDetailsController.dart';
import 'package:internship_mobile_project/Models/Order.dart';

class MyOrdersDetails extends StatelessWidget {
  MyOrdersDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Details")),
      body: _buildMainContent(), // Call the function here
    );
  }

  Widget _buildMainContent() {
    final MyOrdersDetailsController _myorderdetailsController =
        Get.put(MyOrdersDetailsController());
    return Scaffold(
        appBar: AppBar(
          title: Text('My Order Details'),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              Expanded(
                child: Obx(() {
                  if (_myorderdetailsController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_myorderdetailsController.myorders.isEmpty) {
                    return const Center(child: Text("No orders found."));
                  }
                  return ListView.builder(
                    itemCount: _myorderdetailsController.myorders.length,
                    itemBuilder: (context, index) {
                      OrderDetails myorders =
                          _myorderdetailsController.myorders[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(myorders.item),

                              SizedBox(height: 8),
                              Text(myorders.quantity
                                  .toString()), // Add this line to display quantity
                              ElevatedButton(
                                onPressed: () {
                                  Get.toNamed(
                                      '/myordersdetails/${myorders.id}');
                                },
                                child: Text("Delete"),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 36),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ));
  }
}
