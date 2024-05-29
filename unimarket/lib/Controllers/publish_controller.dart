import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:unimarket/Models/product_model.dart';

class PublishController extends ChangeNotifier {
  final TextEditingController iconController = TextEditingController();
  final TextEditingController useController = TextEditingController();

  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerPrice = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  Future addProductToCatalog(ProductModel product, File image) async {
    var imageName = DateTime.now().millisecondsSinceEpoch.toString();
    var storageRef =
        FirebaseStorage.instance.ref().child('products_images/$imageName.jpg');
    var uploadTask = storageRef.putFile(image);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();

    DocumentReference valor =
        await FirebaseFirestore.instance.collection('products').add({
      'name': product.name,
      'price': product.price,
      'category': product.category,
      'image': downloadUrl,
      'used': product.used,
      'description': product.description,
      'sellerId': FirebaseAuth.instance.currentUser!.uid,
      'sold': false,
      'views': 0,
    });

    product.setproductId(valor.id);
  }
}
