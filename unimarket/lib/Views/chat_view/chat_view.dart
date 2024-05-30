import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimarket/Views/chat_view/database_service.dart';
import 'package:unimarket/Views/chat_view/group_tile.dart';
import 'package:unimarket/Views/chat_view/search_group.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {

  String userName = "";
  String email = "";
  //AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState(){
    super.initState();
    gettingUserData();
  }

  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }

  gettingUserData() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData().then((snapshot) {
      setState(() {
        userName = snapshot.docs[0]["fullName"];
        email = snapshot.docs[0]["email"];
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups = snapshot;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text('Chat Groups', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchGroup()));
            }, 
            icon: const Icon(Icons.search)
          )
        ],
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white, size: 30,),
      ),
    );
  }

  popUpDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("Create a new group", textAlign: TextAlign.center,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isLoading ?
                const Center(
                  child: CircularProgressIndicator(color: Colors.red,)
                )
                : TextField(
                  onChanged: (value) {
                    setState(() {
                      groupName = value;
                    });
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.orange
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: ()  async {
                if(groupName != ""){
                  setState(() {
                    _isLoading = true;
                  });
                  DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(userName, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete(() {
                    _isLoading = false;
                  });
                  Navigator.of(context).pop();
                }
              }, 
              child: const Text("Create"),
            )
          ],
        );
      }
    );
  }

  groupList(){
    return StreamBuilder(
      stream: groups, 
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['groups'] != null){
            if(snapshot.data['groups'].length != 0){
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder:(context, index){
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                    groupId: getId(snapshot.data['groups'][reverseIndex]), 
                    groupName: getName(snapshot.data['groups'][reverseIndex]), 
                    userName: snapshot.data['fullName']
                  );
                }
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return const Center(child: CircularProgressIndicator(
            color: Colors.orange,
          ));
        }
      }
    );
  }

  noGroupWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.add_circle, color: Colors.grey[700], size: 75,),
          const SizedBox(height: 20,),
          const Text("You haven't joined to any group, tap on the add icon to create a book or search an existing one using the search button in the top", textAlign: TextAlign.center,)
        ],
      ),
    );
  }


}