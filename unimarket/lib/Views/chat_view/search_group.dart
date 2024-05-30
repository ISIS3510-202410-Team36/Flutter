import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimarket/Views/chat_view/chat_conversation.dart';
import 'package:unimarket/Views/chat_view/database_service.dart';

class SearchGroup extends StatefulWidget {
  const SearchGroup({super.key});

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {

  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  bool _isJoined = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;


  @override
  void initState() {
    getCurrentUserIdandName();
    super.initState();
  }

  getCurrentUserIdandName() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData().then((snapshot) {
      setState(() {
        userName = snapshot.docs[0]["fullName"];
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String r){
    return r.substring(r.indexOf("_")+1);
  }

  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text("Search", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.deepOrange,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search groups...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16)
                    )
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(40)
                    ),
                    child: const Icon(Icons.search, color: Colors.white,),
                  ),
                )
              ],
            ),
          ),
          _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange),)
          : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if(searchController.text.isNotEmpty){
      setState(() {
        _isLoading = true;
      });
      await DatabaseService().searchByName(searchController.text).then((snapshot){
        setState(() {
          searchSnapshot = snapshot;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }
  
  groupList(){
    return hasUserSearched ?
      ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index){
          return groupTile(
            userName,
            searchSnapshot!.docs[index]['groupId'],
            searchSnapshot!.docs[index]['groupName'],
            searchSnapshot!.docs[index]['admin'],
          );
        }
      )
      : Container(

      );
  }

  joinedOrNot(String userName, String groupId, String groupName) async {
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value){
      setState(() {
        _isJoined = value;
      });
    });
  }

  Widget groupTile(String userName, String groupId, String groupName, String admin){
    joinedOrNot(userName, groupId, groupName);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.deepOrange,
        child: Text(
          groupName.substring(0,1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600),),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);
          if(_isJoined){
            setState(() {
              _isJoined = !_isJoined;
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatConversation(groupId: groupId, groupName: groupName, userName: userName)));
          } else {
            setState(() {
              _isJoined = !_isJoined;
            });
          }
        },
        child: _isJoined ?
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
              border: Border.all(color: Colors.white, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Text(
              "Joined",
              style: TextStyle(color: Colors.white),
            ),
          )
          : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.deepOrange,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Text("Join Now", style: TextStyle(color: Colors.white),),
          )
      ),
    );
  }
}