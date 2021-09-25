import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futuresnap) {
        if (futuresnap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, chatsnap) {
              if (chatsnap.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatdocs = chatsnap.data.documents;
              return ListView.builder(
                  reverse: true,
                  itemCount: chatdocs.length,
                  itemBuilder: (ctx, index) {
                    return MessageBubble(
                      chatdocs[index]['text'],
                      futuresnap.data.uid == chatdocs[index]['userId'],
                      chatdocs[index]['username'],
                      chatdocs[index]['userImage'],
                      key: ValueKey(chatdocs[index].documentID),
                    );
                  });
            });
      },
    );
  }
}
