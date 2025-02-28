import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Controllers/CartController.dart';
import 'package:internship_mobile_project/Controllers/MyOrdersController.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController _cartController = Get.put(CartController());
    final MyOrdersController _myordersController =
        Get.put(MyOrdersController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_cartController.cartItems.isEmpty) {
                return Center(
                    child: Text('Your cart is empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey)));
              } else {
                return ListView.builder(
                  itemCount: _cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _cartController.cartItems[index];
                    // Make totalAmount a reactive value.
                    RxDouble totalAmount =
                        (item.price! * item.quantityInCart!).obs;

                    final TextEditingController quantityController =
                        TextEditingController(
                            text: item.quantityInCart.toString());

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        title: Text(item.name ?? 'Unnamed Item',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.teal),
                              onPressed: () {
                                if (item.quantityInCart != null &&
                                    item.quantityInCart! > 1) {
                                  item.quantityInCart =
                                      item.quantityInCart! - 1;
                                  quantityController.text =
                                      item.quantityInCart.toString();
                                  totalAmount.value =
                                      item.price! * item.quantityInCart!;
                                  _cartController.calculateTotalAmount();
                                }
                              },
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: quantityController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                ),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                readOnly: true,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.teal),
                              onPressed: () {
                                if (item.quantityInCart! < item.quantity!) {
                                  item.quantityInCart =
                                      item.quantityInCart! + 1;
                                  quantityController.text =
                                      item.quantityInCart.toString();
                                  totalAmount.value =
                                      item.price! * item.quantityInCart!;
                                  _cartController.calculateTotalAmount();
                                }
                              },
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              return Text(
                                  '\$${totalAmount.value.toStringAsFixed(2)}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold));
                            }),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _cartController.removeItem(item);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Amount: \$${_cartController.totalAmount.value.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _myordersController.addOrder(_cartController.cartItems);
        },
        child: Icon(Icons.shopping_cart_checkout),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
