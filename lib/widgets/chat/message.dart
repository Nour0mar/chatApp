import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resola/widgets/chat/message_bubble.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            reverse: true,
            itemCount: chatSnapshot.data.documents.length,
            itemBuilder: (ctx, i) => MessageBubble(
                chatSnapshot.data.documents[i]['text'],
                chatSnapshot.data.documents[i]['userId']==FirebaseAuth.instance.currentUser.uid,
                chatSnapshot.data.documents[i]['username'],
                chatSnapshot.data.documents[i]['userImage'],
            key: ValueKey(chatSnapshot.data.documents[i].documentID),));
      },
    );
  }
}

// FutureBuilder(
// future: FirebaseAuth.instance.currentUser.reload(),
// builder: (ctx, futureSnapshot) {
// if (futureSnapshot.connectionState == ConnectionState.waiting) {
// return Center(
// child: CircularProgressIndicator(),
// );
// }
// return ListView.builder(
// reverse: true,
// itemCount: chatSnapshot.data.documents.length,
// itemBuilder: (ctx, i) => MessageBubble(
// chatSnapshot.data.documents[i]['text'],
// chatSnapshot.data.documents[i]['userId']==futureSnapshot.data.uid,
// chatSnapshot.data.documents[i]['text'],
// chatSnapshot.data.documents[i]['text']));
// });