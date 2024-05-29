import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimarket/Models/model.dart';

class CartRepository {
  final _DB = FirebaseFirestore.instance;
  int numProds = 0;

  addToCart(String? pId) {
    _DB
        .collection('carts')
        .doc(Model().getUserId())
        .update({pId.toString(): null});
  }

  createCart() {
    _DB
        .collection('carts')
        .doc(Model().getUserId())
        .set({"1": 1}, SetOptions(merge: true));
  }

  getCart(String uId) async {
    await _DB.collection("carts").doc(uId).get().then((value) {
      var valores = value.data();
      valores?.forEach((key, value) {
        if (key != "1") {
          print(key);
          Model().meterProductoCarrito(key);
        }
      });
    });
  }
}
