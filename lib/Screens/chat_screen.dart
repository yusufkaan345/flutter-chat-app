// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Api/apis.dart';
import 'package:chatapp/widgets/message_card.dart';
import 'package:flutter/material.dart';
import '../Models/chat_user.dart';
import '../Models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});

  final ChatUser user;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appbar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getMessages(),
                builder: (context, snapsot) {
                  switch (snapsot.connectionState) {
                    case ConnectionState.waiting:

                    case ConnectionState.none:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapsot.data?.docs;
                      _list.clear();
                      _list.add(Message(
                          told: "xyz",
                          msg: "hii",
                          read: "",
                          type: Type.text,
                          fromId: APIs.user.uid,
                          sent: "12.00 A.M."));
                      _list.add(Message(
                          told: APIs.user.uid,
                          msg: "hii2",
                          read: "",
                          type: Type.text,
                          fromId: "xyz",
                          sent: "12.00 A.M."));

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: _list.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(
                              message: _list[index],
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            "No Text Here ? Say Hi !!👋 ",
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
            _chatInput(),
          ],
        ));
  }

  Widget _appbar() {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: mq.height * .05),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: CachedNetworkImage(
                  width: mq.width * .11,
                  height: mq.width * .11,
                  fit: BoxFit.cover,
                  imageUrl: widget.user.image.toString(),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.user.name.toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Last seen not awailable",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.emoji_emotions),
                    color: Colors.blueAccent,
                    iconSize: 25,
                  ),
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Type Something...",
                      hintStyle: TextStyle(color: Colors.blue),
                      border: InputBorder.none,
                    ),
                  )),
                  //image button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.image),
                    color: Colors.blueAccent,
                    iconSize: 26,
                  ),
                  //camera button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt_rounded),
                    color: Colors.blueAccent,
                    iconSize: 26,
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
            shape: CircleBorder(),
            color: Colors.green,
            minWidth: 5,
            onPressed: () {},
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
