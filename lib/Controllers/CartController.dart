import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internship_mobile_project/Models/Item.dart';
import 'package:internship_mobile_project/Models/Category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  // Observable list to store cart items
  var cartItems = <Item>[].obs;

  var totalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Update totalAmount whenever cartItems change
    ever(cartItems, (_) => calculateTotalAmount());
  }

  void calculateTotalAmount() {
    totalAmount.value = cartItems.fold(
        0, (sum, item) => sum + (item.price! * item.quantityInCart!));
  }

  void addToCart(Item item, int quantity) {
    // Check if the item already exists in the cart
    int index = cartItems.indexWhere((cartItem) => cartItem.name == item.name);

    if (index != -1) {
      // If item exists, update quantity
      cartItems[index].quantityInCart =
          (cartItems[index].quantityInCart ?? 0) + quantity;
    } else {
      // If item does not exist, add it with the specified quantity
      item.quantityInCart = quantity;
      cartItems.add(item);
    }

    print("Added ${item.name} (Quantity: $quantity) to cart");
  }

  void editQuantity(Item item, int newQuantity) {
    // Find the item in the cart
    int index = cartItems.indexWhere((cartItem) => cartItem.name == item.name);

    if (index != -1) {
      // Update the quantity

      cartItems[index].quantityInCart = newQuantity;

      cartItems.refresh(); // Force UI update
    }

    print("Updated quantity of ${item.name} to $newQuantity");
  }

  void removeItem(Item item) {
    // Remove the item from the cart

    cartItems.removeWhere((cartItem) => cartItem.name == item.name);
    cartItems.refresh(); // Force UI update

    print("Removed ${item.name} from cart");
  }
}
