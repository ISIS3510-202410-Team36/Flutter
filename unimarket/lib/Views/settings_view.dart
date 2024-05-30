import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:unimarket/Views/login_view.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatelessWidget {
  final Connectivity connectivity = Connectivity();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Change Information'),
            onTap: () {
              // Navigate to change information page
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ChangeInformationPage()),
              // );
            },
          ),
          ListTile(
            title: Text('Sign Out'),
            onTap: () {
              // Sign out logic
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Sign Out'),
                    content: Text('Are you sure you want to sign out?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Sign Out'),
                        onPressed: () {
                          // Perform sign out
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginView()));
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text('Support the developers'),
            onTap: () async {
              // Support developers logic
              List<ConnectivityResult> connectivityResult =
                  await revisarConexion();
              if (connectivityResult.contains(ConnectivityResult.none)) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('No Netwoek Connection'),
                      content: Text(
                          'We could not direct you to the webpage, because there is no internet connection'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                _launchURL();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<ConnectivityResult>> revisarConexion() async {
    return connectivity.checkConnectivity();
  }

  _launchURL() async {
    final Uri url =
        Uri.parse('https://github.com/ISIS3510-202410-Team36/Flutter');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
