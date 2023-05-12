// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key});

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
              title: Text("data"),
              subtitle: Text(
                "Last User Message",
                maxLines: 1,
              ),
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              trailing: Text(
                "10.50 PM",
                style: TextStyle(color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
