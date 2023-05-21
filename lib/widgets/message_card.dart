// ignore_for_file: prefer_const_constructors

import "package:cached_network_image/cached_network_image.dart";
import "package:chatapp/Api/apis.dart";
import "package:chatapp/Helper/my_date_util.dart";
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
  void initState() {
    final type = widget.message.type;
    print(type.runtimeType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? greenMessage()
        : blueMessage();
  }

  Widget blueMessage() {
    final type = widget.message.type;
    print(type);
    if (widget.message.read.toString().isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                color: Color.fromARGB(255, 222, 236, 248),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: type == "Type.text"
                      ? Text(
                          widget.message.msg.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        )
                      : ClipRRect(
                          child: CachedNetworkImage(
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            imageUrl: widget.message.msg.toString(),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image,
                              size: 70,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 8),
                  child: Text(
                    MyDate.getFormattedTime(
                        context: context, time: widget.message.sent.toString()),
                    style: TextStyle(fontSize: 9, color: Colors.black45),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget greenMessage() {
    final String type = widget.message.type.toString();
    print(type);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.message.read.toString().isNotEmpty)
          Icon(
            Icons.done_all_rounded,
            color: Colors.blue,
            size: 20,
          ),
        Flexible(
          child: Container(
            constraints: BoxConstraints(minWidth: 0, maxWidth: 350),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                color: Color.fromARGB(255, 228, 249, 228),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: type == "Type.text"
                      ? Text(
                          widget.message.msg.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        )
                      : ClipRRect(
                          child: CachedNetworkImage(
                            width: 350,
                            height: 450,
                            fit: BoxFit.cover,
                            imageUrl: widget.message.msg.toString(),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_aspect_ratio_outlined,
                              size: 70,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 8),
                  child: Text(
                    MyDate.getFormattedTime(
                        context: context, time: widget.message.sent.toString()),
                    style: TextStyle(fontSize: 9, color: Colors.black45),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
