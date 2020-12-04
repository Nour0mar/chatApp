import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resola/widgets/chat/message.dart';
import 'package:resola/widgets/chat/new_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print(msg);
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      print(msg);
      return;
    });
    fbm.subscribeToTopic('chat');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resola'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(Icons.more_vert,color: Theme.of(context).primaryIconTheme.color,),
              onChanged: (item){
            if(item=='Logout'){
              FirebaseAuth.instance.signOut();
            }
              },
          items: [
            DropdownMenuItem(child: Container(
              child: Row(
                children: [
                  Icon(Icons.exit_to_app),
                  SizedBox(width: 8,),
                  Text("Logout")
                ],
              ),
            ),
            value: 'Logout',
            )
          ],
          )
        ],
      ),
      body:Container(
        child: Column(
          children: [
            Expanded(child: Message()),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
