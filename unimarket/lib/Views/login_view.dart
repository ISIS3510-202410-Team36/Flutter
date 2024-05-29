import 'dart:isolate';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:unimarket/Controllers/network_controller.dart';
import 'package:unimarket/Views/register_view.dart';
import 'package:unimarket/Controllers/auth_controller.dart';
import 'package:unimarket/Views/body_view.dart';
import 'package:unimarket/globals.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late AuthController _authController;
  final Connectivity connectivity = Connectivity();
  final Globals globals = Globals();

  NetworkController netw = NetworkController();
  String email = "";
  String contrasena = "";
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();
  String hintTextEmailUsername = 'Email/Username';
  String hintTextPass = "******";

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    NetworkController netw = new NetworkController();
    globals.getNumberOfNetworkIsolates() < 1 ? netCheck() : 1;

    _authController = AuthController();
    super.initState();
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

  void showNetworkErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 212, 129, 12),
          title: const Text('Network Error'),
          content: const Text(
              "You are currently experiencing connection loss, please connect to the internet to have a better experience"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // globals.getNumberOfNetworkIsolates() < 1 ? netCheck() : 1;
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 212, 129, 12),
          title: const Text('Oops!'),
          content: const Text(
              'Something went wrong singing in. Make sure the credentials you are providing are correct and that you already have an account registered'),
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

  @override
  Widget build(BuildContext context) {
    void authenticationProcess(bool existingUser) {
      if (existingUser) {
        FlutterIsolate.killAll();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BodyView()));
      } else {
        showErrorDialog(context);
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 206, 190),
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
                height: 550,
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
                            'Sign in',
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
                            authenticationProcess(await _authController
                                .ingresar(email, contrasena));
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
                            'Sign in',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            FlutterIsolate.killAll();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterView()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
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
}
