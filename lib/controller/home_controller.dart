import 'package:advance_exam_2/helper/db_helper.dart';
import 'package:advance_exam_2/helper/firestore_helper.dart';
import 'package:advance_exam_2/model/pro_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return FirestoreHelper.instance.getProducts();
  }

  Future<bool> addProduct({required ProductModel product}) async {
    if (product.id.isNotEmpty &&
        product.name.isNotEmpty &&
        product.price.isNotEmpty) {
      FirestoreHelper.instance.addPro(product: product);
      update();
      return true;
    } else {
      Get.snackbar("Error", "Please fill all the fields",
          backgroundColor: Colors.red);
      return false;
    }
  }

  bool updateProduct({required ProductModel product}) {
    if (product.id.isNotEmpty &&
        product.name.isNotEmpty &&
        product.price.isNotEmpty) {
      FirestoreHelper.instance.updatePro(product: product);
      update();
      return true;
    } else {
      Get.snackbar("Error", "Please fill all the fields",
          backgroundColor: Colors.red);
      return false;
    }
  }

  void deleteProduct({required String id}) {
    FirestoreHelper.instance.deletePro(id: id);
    update();
  }

  Future<void> addToCart(ProductModel product) async {
    await DBHelper.dbHelper.insertCartItem(product);
    Get.snackbar("Added", "${product.name} added to cart",
        backgroundColor: Colors.green);
    update();
  }

  Future<List<ProductModel>> fetchCartItems() async {
    update();
    return await DBHelper.dbHelper.getCartItems();
  }

  Future<void> removeCartItem(String id) async {
    await DBHelper.dbHelper.deleteCartItem(id);
    update();
  }
}