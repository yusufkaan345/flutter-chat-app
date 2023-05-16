// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Models/chat_user.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final ChatUser user;
  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.purple.shade100,
        elevation: 4,
        child: InkWell(
          onTap: () {},
          child: Center(
            child: ListTile(
                title: Text(widget.user.name.toString()),
                subtitle: Text(
                  widget.user.about.toString(),
                  maxLines: 1,
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: CachedNetworkImage(
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image.toString(),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                trailing: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent.shade400,
                      borderRadius: BorderRadius.circular(15)),
                )),
          ),
        ),
      ),
    );
  }
}
