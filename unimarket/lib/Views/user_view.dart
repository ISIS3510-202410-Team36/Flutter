import 'package:flutter/material.dart';
import 'package:unimarket/Models/Repository/sharedPreferences.dart';

class UserView extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<UserView> {
  // Example values for demonstration
  @override
  void initState() {
    load();
    userInfo = {
      'Name': name,
      'Last Name': lastname,
      'Nickname': nick,
      'Age': age,
      'University': uni,
      'Gender': gen,
      'Extra Information about yourself': extra,
    };
  }

  late String name;
  late String lastname;
  late String age;
  late String gen;
  late String uni;
  late String nick;
  late String extra;
  late Map<String, String> userInfo = {
    'Name': "name",
    'Last Name': " lastname",
    'Nickname': "nick",
    'Age': "age",
    'University': "uni",
    'Gender': "gen",
    'Extra Information about yourself': "extra",
  };

  void load() async {
    name = await SharedPreferencesR().getName();
    lastname = await SharedPreferencesR().getLast();
    age = await SharedPreferencesR().getAge();
    gen = await SharedPreferencesR().getGender();
    uni = await SharedPreferencesR().getUniversity();
    nick = await SharedPreferencesR().getNickName();
    extra = await SharedPreferencesR().getExtra();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This is the info you provided us!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userInfo.length,
                itemBuilder: (context, index) {
                  String key = userInfo.keys.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$key: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            userInfo[key]!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
