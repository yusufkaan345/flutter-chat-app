// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:math';

import 'package:chatapp/Api/apis.dart';
import 'package:chatapp/Models/chat_user.dart';
import 'package:chatapp/widgets/chat_user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});
  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final List<ChatUser> UserList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chit Chat"),
        leading: Icon(Icons.home),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: Icon(Icons.add_comment_rounded),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: APIs.firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Bir hata oluştu.'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final documents = snapshot.data!.docs;
              documents.map((e) => ChatUser.fromJson(e));
              return ListView.builder(
                itemCount: UserList.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot document = documents[index];
                  //print(jsonEncode(document.data()));
                  return UserCard();
                },
              );
            },
          )),
    );
  }
}
