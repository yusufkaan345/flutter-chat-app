// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Helper/my_date_util.dart';
import 'package:chatapp/Models/chat_user.dart';
import 'package:chatapp/Screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../Api/apis.dart';
import '../Models/message.dart';

class UserCard extends StatefulWidget {
  final ChatUser user;
  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  //last message info if null ->no message
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Color.fromARGB(255, 146, 114, 252),
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: Center(
            child: StreamBuilder(
                stream: APIs.getLastMessage(widget.user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Yüklenirken gösterilecek ilerleme göstergesi
                    return CircularProgressIndicator();
                  }
                  final data = snapshot.data?.docs;
                  final list =
                      data?.map((e) => Message.fromJson(e.data())).toList();

                  if (list!.isNotEmpty) {
                    _message = list[0];
                  }
                  return ListTile(
                    title: Text(
                      widget.user.name.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      _message != null
                          ? _message!.type.toString() == "Type.image"
                              ? "image"
                              : _message!.msg.toString()
                          : widget.user.about.toString(),
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: CachedNetworkImage(
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.image.toString(),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    trailing: _message == null
                        ? null
                        : _message!.read.toString().isEmpty &&
                                _message!.fromId != APIs.user.uid
                            ? Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.purple.shade400,
                                    borderRadius: BorderRadius.circular(15)),
                              )
                            : Text(
                                MyDate.getlastMessageTime(
                                        context: context,
                                        time: _message!.sent.toString())
                                    .toString(),
                                style: TextStyle(color: Colors.white)),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
