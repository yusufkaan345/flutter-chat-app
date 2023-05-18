// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Constants/text_const.dart';
import 'package:chatapp/Helper/dialogs.dart';
import 'package:chatapp/Screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../Api/apis.dart';
import '../Models/chat_user.dart';

class ProphileScreen extends StatefulWidget {
  final ChatUser user;
  const ProphileScreen({super.key, required this.user});
  @override
  State<ProphileScreen> createState() => _ProphileScreenState();
}

class _ProphileScreenState extends State<ProphileScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _image;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Prophile Screen"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                Dialogs().showProgressBar(context);
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => SignUpPage()),
                );
              });
            });
          },
          label: Text("Log Out"),
          icon: Icon(Icons.exit_to_app),
          backgroundColor: Colors.redAccent,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: mq.width * 0.05,
                    right: mq.height * .06,
                    left: mq.height * .06),
                child: Stack(
                  children: [
                    _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: Image.file(
                              File(_image!),
                              width: mq.width * .4,
                              height: mq.width * .4,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: CachedNetworkImage(
                              width: mq.width * .4,
                              height: mq.width * .4,
                              fit: BoxFit.cover,
                              imageUrl: widget.user.image.toString(),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )),
                    Positioned(
                      bottom: 0,
                      right: 0,

                      //Edit image button
                      child: MaterialButton(
                        onPressed: () {
                          _showBottomSheet();
                        },
                        shape: CircleBorder(),
                        color: Colors.white,
                        child: Icon(
                          Icons.edit,
                          color: Colors.amber,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: mq.height * 0.05),
              Text(
                widget.user.email.toString(),
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: mq.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * .10),
                child: TextFormField(
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    initialValue: widget.user.name.toString(),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        hintText: "Name",
                        label: Text("Name"))),
              ),
              SizedBox(height: mq.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * .10),
                child: TextFormField(
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    initialValue: widget.user.about.toString(),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        hintText: "Hey! I am using chit chat ",
                        label: Text("About"))),
              ),
              SizedBox(height: mq.height * 0.04),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      minimumSize: Size(mq.width * .4, mq.height * .055)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      APIs.updateUserInfo().then((value) {
                        final snackBar = SnackBar(
                          content:
                              Text('User info updated!'), // Snackbar içeriği
                          duration: Duration(
                              seconds: 2), // Snackbar'ın görüntülenme süresi
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    }
                  },
                  icon: Icon(Icons.edit),
                  label: Text(
                    "Edit",
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20, bottom: 50),
            children: [
              Text(
                "Pick Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 50,
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: CircleBorder(),
                        fixedSize: Size(100, 110),
                      ),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          _image = image?.path;
                        });
                        APIs.updateProfileImage(File(_image!));

                        //for hiding bottom sheet
                        Navigator.pop(context);
                      },
                      child: Image.asset(RegisterConst.addImage)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(100, 110)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        setState(() {
                          _image = image?.path;
                        });
                        APIs.updateProfileImage(File(_image!));
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      },
                      child: Image.asset(RegisterConst.cameraImage))
                ],
              )
            ],
          );
        });
  }
}
