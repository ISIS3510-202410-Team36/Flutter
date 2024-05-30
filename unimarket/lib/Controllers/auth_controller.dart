import 'package:firebase_auth/firebase_auth.dart';
import 'package:unimarket/Controllers/search_controllerUnimarket.dart';
import 'package:unimarket/Models/Repository/cartRepository.dart';
import 'package:unimarket/Models/model.dart';
import 'package:unimarket/globals.dart';

class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future ingresar(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? usuario = result.user;
      String? uuid = usuario?.uid.toString();
      SearchControllerUnimarket().cargarProductos();
      Model().setUserId(uuid);
      Globals().setSessionUserId(uuid!);
      CartRepository().createCart();
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  Future registrar(String email, String contrasena) async {
    try {
      UserCredential resultado = await auth.createUserWithEmailAndPassword(
          email: email, password: contrasena);
      User? usuario = resultado.user;
      return usuario;
    } catch (e) {
      return e;
    }
  }
}
