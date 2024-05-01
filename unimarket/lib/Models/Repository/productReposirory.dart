import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimarket/Models/Repository/cartRepository.dart';
import 'package:unimarket/Models/model.dart';
import 'package:unimarket/Models/product_model.dart';
import 'package:unimarket/Models/seller_model.dart';
import 'package:uuid/uuid.dart';

class ProductRepository {
  final _DB = FirebaseFirestore.instance;
  int numProds = 0;

  void getData() async {
    await _DB.collection("products").get().then((value) {
      for (var i in value.docs) {
        ProductModel producto = ProductModel(
            i.id,
            i.data()["name"],
            i.data()["category"],
            i.data()["price"],
            i.data()["used"],
            i.data()["image"],
            i.data()["sold"],
            i.data()["views"],
            i.data()["description"]);
        Model().addProduct(producto);
      }
    });
    CartRepository().getCart(Model().userId);
  }

  Future getFilteredProducts(String category, bool use, List<ProductModel> lista) async {
    await FirebaseFirestore.instance.collection("products")
      .where(Filter.and(Filter('category', isEqualTo: category), 
        Filter('used', isEqualTo: use))).get().then((value){
          for (var i in value.docs) {
            ProductModel producto = ProductModel(
                i.id,
                i.data()["name"],
                i.data()["category"],
                i.data()["price"],
                i.data()["used"],
                i.data()["image"],
                i.data()["sold"],
                i.data()["views"],
                i.data()["description"]);
            Model().addFilteredProduct(producto, lista);
          }
    });
  }
}
