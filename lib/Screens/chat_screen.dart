// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Api/apis.dart';
import 'package:chatapp/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final _textController = TextEditingController();
  ScrollController _controller = ScrollController();

  bool _showEmoji = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showEmoji) {
          setState(
              () => _showEmoji = false); // _showEmoji'yi false olarak ayarlayın
          return false; // Geri düğmesine basıldığında sayfanın kapanmamasını sağlayın
        } else {
          return true; // Geri düğmesine basıldığında sayfanın normal şekilde kapanmasını sağlayın
        }
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appbar(),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Container(
              color: Colors.purple.shade300,
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: APIs.getMessages(widget.user),
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
                            _list = data
                                    ?.map((e) => Message.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                controller: _controller,
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
                  if (_showEmoji)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .35,
                      child: EmojiPicker(
                        textEditingController: _textController,
                        config: Config(
                          columns: 8,
                          initCategory: Category.SMILEYS,
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                        ),
                      ),
                    )
                ],
              ),
            ),
          )),
    );
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
                    onPressed: () {
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: Icon(Icons.emoji_emotions),
                    color: Colors.blueAccent,
                    iconSize: 25,
                  ),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    onTap: () {
                      if (_showEmoji) {
                        setState(() => _showEmoji = false);
                      }
                    },
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      if (_showEmoji) {
                        FocusScope.of(context).unfocus();
                      }
                      FocusScope.of(context).unfocus();
                    },
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Type Something...",
                      hintStyle: TextStyle(color: Colors.blue),
                      border: InputBorder.none,
                    ),
                  )),
                  //image button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 70);

                      await APIs.sendImage(widget.user, File(image!.path));
                    },
                    icon: Icon(Icons.image),
                    color: Colors.blueAccent,
                    iconSize: 26,
                  ),
                  //camera button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);

                      await APIs.sendImage(widget.user, File(image!.path));
                    },
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
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                _textController.text = "";
              }
            },
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
