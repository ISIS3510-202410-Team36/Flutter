import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:unimarket/Views/chat_view/database_service.dart';
import 'package:unimarket/Views/chat_view/group_info.dart';
import 'package:unimarket/Views/chat_view/message_tile.dart';
import 'package:unimarket/theme.dart';

class ChatConversation extends StatefulWidget {

  final String groupId;
  final String groupName;
  final String userName;

  const ChatConversation({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  });

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {

  String admin = "";
  Stream<QuerySnapshot>? chats;
  List<Map<String, dynamic>>? oldChats;
  TextEditingController messageController = TextEditingController();

  late StreamSubscription subscription;
  bool _isConnected = true;
  bool isAlertSet = false;

  @override
  void initState() {
    getChatAndAdmin();
    getConnectivity();
    updateChats1();
    super.initState();
  }

  getConnectivity(){
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      bool connectionCheck = await InternetConnectionChecker().hasConnection;
      connectionCheck ?
        connectionRestored()
        : connectionLost();
     });
  }

  connectionRestored() {
    print("restored");
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).sendOfflineMessages(widget.groupId, widget.userName).then(
      (value) => setState(() {
        oldChats = null;
      })
    );
    updateChats1();
    setState(() {
      _isConnected = true;
    });
  }

  connectionLost(){
    print("lost");
    isAlertSet ? null : showNoConnectionDialog();
    setState(() {
      _isConnected = false;
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  getChatAndAdmin(){
    DatabaseService().getChats(widget.groupId).then((value){
      setState(() {
        chats = value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  updateChats() async {
    Stream<QuerySnapshot> newChats = await DatabaseService().updateChats(chats);
    setState(() {
      chats = newChats;
    });
  }

  updateChats1() async {
    List<Map<String, dynamic>> messages = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).updateChats1(widget.userName);
    setState(() {
      oldChats = messages;
    }); 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(widget.groupName),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => 
                GroupInfo(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  adminName: admin,
                )));
            }, 
            icon: const Icon(Icons.info)
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              chatMessages(),
              chatOfflineMessages(),
              const SizedBox(height: 90,),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Send a message",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    )
                  ),
                  const SizedBox(width: 12,),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(Icons.send, color: Colors.white,),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages(){
    return StreamBuilder(
      stream: chats, 
      builder: (context, AsyncSnapshot snapshot){
        return snapshot.hasData ?
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.docs[index]['message'], 
                sender: snapshot.data.docs[index]['sender'], 
                sentByMe: widget.userName == snapshot.data.docs[index]['sender'],
                alreadySent: true,
              );
            }
          ) : Container();
      },
    );
  }

  chatOfflineMessages() {
    if(oldChats!=null && oldChats!.isNotEmpty){
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: oldChats!.length,
        itemBuilder: ((context, index) {
          return MessageTile(
            message: oldChats![index]['message'], 
            sender: widget.userName, 
            sentByMe: true, 
            alreadySent: false
          );
        })
      );
    } else {
      return Container();
    }
  }

  sendMessage() async {

    if(messageController.text.isNotEmpty){
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch, 
      };

      if(_isConnected) {
        DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      } else {
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).saveMessageOffline(chatMessageMap);
        updateChats1();
      }
      
      setState(() {
        messageController.clear();
      });
    }
  }

  void showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Provider.of<ThemeNotifier>(context).getTheme().cardColor, // Set background color to green
          title: const Text('No internet connection'),
          content: const Text(
              'Seems to be that your device has no connection in this moment. The messages wont be sent until the connection is restored'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isAlertSet = false;
                });
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }
}