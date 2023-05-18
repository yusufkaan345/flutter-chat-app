import "package:chatapp/Api/apis.dart";
import "package:flutter/material.dart";

import "../Models/message.dart";

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? greenMessage()
        : blueMessage();
  }

  Widget blueMessage() {
    return Container(
      child: Text(widget.message.msg.toString()),
    );
  }

  Widget greenMessage() {
    return Container();
  }
}
