// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names, unused_field
import 'dart:convert';
import 'dart:math';

import 'package:chatapp/Api/apis.dart';
import 'package:chatapp/Models/chat_user.dart';
import 'package:chatapp/Screens/prophile_screen.dart';
import 'package:chatapp/Screens/sign_up.dart';
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
  List<ChatUser> UserList = [];
  List<ChatUser> _searchList = [];
  bool _isSearch = false;

  @override
  void initState() {
    APIs.getSelfInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: _isSearch
              ? TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search : Name, Email...",
                  ),
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 0.7,
                  ),
                  //when search text change update to seachlist
                  onChanged: (val) {
                    //search operations
                    _searchList.clear();
                    for (var i in UserList) {
                      if (i.name
                              .toString()
                              .toLowerCase()
                              .contains(val.toLowerCase()) ||
                          i.name.toString().contains(val.toLowerCase())) {
                        _searchList.add(i);
                        setState(() {
                          _searchList;
                        });
                      }
                    }
                  },
                )
              : Text("Chit Chat"),
          leading: Icon(Icons.home),
          actions: [
            //search user button
            IconButton(
                onPressed: () {
                  setState(() {
                    _isSearch = !_isSearch;
                  });
                },
                icon: Icon(_isSearch ? Icons.close : Icons.search)),

            //user prophile icon
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProphileScreen(
                                user: APIs.me,
                              )));
                },
                icon: Icon(Icons.more_vert)),
          ],
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            onPressed: () async {
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => SignUpPage()));
            },
            child: Icon(Icons.add_comment_rounded),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Bir hata oluştu.'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final documents = snapshot.data!.docs;
                UserList = documents
                    .map((e) =>
                        ChatUser.fromJson(e.data() as Map<String, dynamic>))
                    .toList();
                if (UserList.isNotEmpty) {
                  return ListView.builder(
                    itemCount: _isSearch ? _searchList.length : UserList.length,
                    itemBuilder: (context, index) {
                      return UserCard(
                        user: _isSearch ? _searchList[index] : UserList[index],
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      "There is no one here!!",
                      style: TextStyle(fontSize: 25),
                    ),
                  );
                }
              },
            )),
      ),
    );
  }
}
