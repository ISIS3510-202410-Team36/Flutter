import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {

  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future gettingUserData() async {
    QuerySnapshot snapshot = await userCollection.where("uid", isEqualTo: uid).get();
    return snapshot;
  }

  Future getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "uid": uid,
    });
  }

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  Future getChats(String groupId) async {
    return groupCollection.doc(groupId).collection("messages").orderBy("time").snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  Future getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  Future searchByName(String groupName) async {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  Future<bool> isUserJoined(String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];

    if(groups.contains("${groupId}_$groupName")){
      return true;
    } else {
      return false;
    }
  }


  Future toggleGroupJoin(String groupId, String userName, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    if(groups.contains("${groupId}_$groupName")){
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"]) 
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"]) 
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"]) 
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"]) 
      });
    }
  }


  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  Future saveMessageOffline(Map<String, dynamic> chatMessageData) async {

    SharedPreferences prefs = await _prefs;
    String keyPrefs = 'messages_$uid';

    List<String>? messagesToSend;

    if (prefs.getStringList(keyPrefs) != null){
      messagesToSend = prefs.getStringList(keyPrefs);
      messagesToSend!.add(chatMessageData["message"]);
      prefs.setStringList(keyPrefs, messagesToSend);
    } else {
      messagesToSend = [];
      messagesToSend.add(chatMessageData['message']);
      prefs.setStringList(keyPrefs, messagesToSend);
    }
  }


  Future sendOfflineMessages(String groupId, String userName) async {

    SharedPreferences prefs = await _prefs;
    String keyPrefs = 'messages_$uid';

    List<String>? messagesToSend = await getOfflineMessages();
    List<String> missingMessages = messagesToSend!;

    if(messagesToSend != null){
      for(String message in messagesToSend){
        Map<String, dynamic> chatMessageMap = {
          "message": message,
          "sender": userName,
          "time": DateTime.now().millisecondsSinceEpoch, 
        };

        groupCollection.doc(groupId).collection("messages").add(chatMessageMap);
        groupCollection.doc(groupId).update({
          "recentMessage": chatMessageMap['message'],
          "recentMessageSender": chatMessageMap['sender'],
          "recentMessageTime": chatMessageMap['time'].toString(),
        });
        missingMessages.remove(message);
        prefs.remove(keyPrefs);
        prefs.setStringList(keyPrefs, missingMessages);
      }
    }
  }

  getOfflineMessages() async {
    SharedPreferences prefs = await _prefs;
    String keyPrefs = 'messages_$uid';
    return prefs.getStringList(keyPrefs);
  }


  Future updateChats(Stream<QuerySnapshot>? oldChats) async {

  }


  Future updateChats1(String user) async {
    List<Map<String, dynamic>> updatedMessages = [];

    if(await getOfflineMessages() != null){

      List<String> offlineMessages = await getOfflineMessages();

      int index = 0;

      while(index < offlineMessages.length){
        Map<String, dynamic> chatMessage = {
          "message": offlineMessages[index],
          "sender": user,
          "time": DateTime.now().millisecondsSinceEpoch, 
        };
        updatedMessages.add(chatMessage);
        index++;
      }
    }
    return updatedMessages;
  }
}