import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

enum IconLabel {
  sent('Sent', Icons.done_all_rounded),
  notSent('Not sent', Icons.timer_10_outlined);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

class MessageTile extends StatefulWidget {

  final String message;
  final String sender;
  final bool sentByMe;
  final bool alreadySent;

  const MessageTile({
    super.key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.alreadySent,
  });

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {

  late StreamSubscription subscription;
  bool _isConnected = true;

  @override
  void initState() {
    getConnectivity();
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

  connectionRestored(){
    print("restored");
    setState(() {
      _isConnected = true;
    });
  }

  connectionLost(){
    print("lost");
    setState(() {
      _isConnected = false;
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: widget.sentByMe ? 0 : 24, right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: widget.sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
        margin: widget.sentByMe ?
          const EdgeInsets.only(left: 30)
          : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius:widget.sentByMe ?
            const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),

            )
            : const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),

            ),

          color: widget.sentByMe ?
            Colors.deepOrange
            : Colors.grey[700]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(), 
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
            ),
            const SizedBox(height: 8,),
            Text(widget.message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16),)
          ],
        ),
      ),
      widget.alreadySent ? const Icon(Icons.done_all_rounded) : const Icon(Icons.timer_outlined),
        ],
      )
    );
  }
}