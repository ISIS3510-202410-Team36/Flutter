import 'dart:isolate';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimarket/Controllers/network_controller.dart';
import 'package:unimarket/Views/login_view.dart';
import 'package:unimarket/Controllers/auth_controller.dart';
import 'package:unimarket/globals.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String email = "";
  String contrasena = "";
  AuthController autenticador = AuthController();
  late bool registroExitoso;
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();
  String hintTextEmailUsername = 'Email/Username';
  String hintTextPass = "******";
  final Globals globals = Globals();
  NetworkController netw = NetworkController();
  final Connectivity connectivity = Connectivity();

  @override
  void initState() {
    autenticador = AuthController();
    NetworkController netw = new NetworkController();
    super.initState();
    globals.getNumberOfNetworkIsolates() < 1 ? netCheck() : 1;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintTextEmailUsername = '';
      } else {
        hintTextEmailUsername = 'Email/Username';
      }
      setState(() {});
    });
    focusNode2.addListener(() {
      if (focusNode2.hasFocus) {
        hintTextPass = '';
      } else {
        hintTextPass = "******";
      }
      setState(() {});
    });
  }

  void netCheck() async {
    var receivePort = ReceivePort();
    var rootToken = RootIsolateToken.instance!;

    globals.increaseNetworkIsolate();
    final netIsol = await Isolate.spawn(
        netw.checkNetwork, [receivePort.sendPort, rootToken, connectivity]);

    receivePort.listen((total) {
      print("total");
      globals.decreaseNetworkIsolate();
      showNetworkErrorDialog(context);
    });
  }

  void showNetworkErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 212, 129, 12),
          title: const Text('Network Error'),
          content: const Text("Connect to internet please"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                globals.getNumberOfNetworkIsolates() < 1 ? netCheck() : 1;
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 212, 129, 12),
          title: const Text('Oops!'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          title: const Text('Success!'),
          content: const Text('Registration successful! Now please sign in'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginView()));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String labelText, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 230, top: 17),
          child: Text(
            labelText,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          onChanged: (val) {
            setState(() => email = val);
          },
          focusNode: focusNode,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintTextEmailUsername,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField1(String labelText, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 230, top: 17),
          child: Text(
            labelText,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          onChanged: (val) {
            setState(() => contrasena = val);
          },
          focusNode: focusNode2,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintTextPass,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 206, 190),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginView()));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            color: const Color.fromARGB(255, 250, 206, 190),
            child: const Center(
              child: Image(
                image: AssetImage("assets/images/logo.png"),
                height: 100,
                width: 100,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 350,
                margin: const EdgeInsets.only(bottom: 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 255, 100, 35),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(bottom: 35),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        _buildTextField('Email/Username'),
                        const SizedBox(height: 20.0),
                        _buildTextField1('Password', obscureText: true),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            autenticador
                                .registrar(email, contrasena)
                                .then((value) => manejarValorRegistro(value));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  manejarValorRegistro(value) {
    if (value is User) {
      showSuccessDialog(context);
    } else {
      var valor = value.message as String;
      if (valor == "Unable to establish connection on channel.") {
        valor = "Please make sure you provide an email and password";
      }

      showErrorDialog(context, valor);
    }
  }
}
