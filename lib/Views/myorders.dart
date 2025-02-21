import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:internship_mobile_project/Controllers/CartController.dart';
import 'package:internship_mobile_project/Controllers/MyOrdersController.dart';
import 'package:internship_mobile_project/Models/Category.dart';
import 'package:internship_mobile_project/Models/myorders.dart';



class MyOrders extends StatelessWidget {
  final MYOrdersController _myordersController = Get.put(MyOrdersController());
  final CartController _cartController = Get.put(CartController());
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 16.0),
          Expanded(
            child: Obx(() {
              if (_myordersController.myorders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                myordersCount: _myordersController.myorders.length,
                myordersBuilder: (context, index) {
                  MyOrders myorders = _myordersController.myorders[index];
                

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        myorders.id,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(myorders.user_id.toString()),
                          SizedBox(height: 8),
                          Text("${myorders.total_amount.toString()} $"),
                          SizedBox(height: 8),
                          Text(myorders.created_at),
                          ElevatedButton(
                            onPressed: () {

                            },
                            child: Text("View Details"),
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
    );
  }
}
