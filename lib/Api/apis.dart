import 'dart:io';
import 'package:chatapp/Models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Models/message.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;
  //is user exist or not
  static Future<bool> isUserExist() async {
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

  //for storing self information
  static late ChatUser me;

  //Get self info
  static Future<void> getSelfInfo() async {
    await firestore
        .collection("users")
        .doc(user.uid)
        .get()
        .then((userMe) async {
      if (userMe.exists) {
        me = ChatUser.fromJson(userMe.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final newUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Yusuf Kaan adamdır.(Edit)",
      image:
          "https://lh3.googleusercontent.com/a/AGNmyxY0l_04ldQ0WZI2HFTm_jF4DvnkXY1NqbnHX_uQ=s96-c",
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: "",
    );
    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(newUser.toJson());
  }

  static Future<void> createUserCustom(String name, String email) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final newUser = ChatUser(
      id: user.uid,
      name: name,
      email: email,
      about: "Hey!Iam using chit chat",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: "",
    );
    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(newUser.toJson());
  }

  //get all users from firebase database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return APIs.firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //update user information
  static Future<void> updateUserInfo() async {
    await firestore
        .collection("users")
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Future<void> updateProfileImage(File file) async {
    //getting image file extention (jpg  or png??)
    final ext = file.path.split(".").last;
    //storage file ref with path
    final ref = storage.ref().child('profile_images/${user.uid}.$ext');
    //upload image
    await ref.putFile(file, SettableMetadata(contentType: 'images/$ext'));
    me.image = await ref.getDownloadURL();
    //uploading image in firestore database
    firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

//////////////////CHAT SCREEN APIS//////////
//getting conversation id
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

//get all message of a spesific conversation from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      ChatUser user) {
    return APIs.firestore
        .collection('chats/${getConversationId(user.id.toString())}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //for sending message
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final Message message = Message(
        told: chatUser.id,
        msg: msg,
        read: "",
        type: type,
        fromId: user.uid,
        sent: time);
    final ref = firestore.collection(
        'chats/${getConversationId(chatUser.id.toString())}/messages');
    await ref.doc(time).set(message.toJson());
  }

  // update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection(
            'chats/${getConversationId(message.fromId.toString())}/messages')
        .doc(message.sent)
        .update({"read": DateTime.now().microsecondsSinceEpoch.toString()});
  }

//get only last message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id.toString())}/messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendImage(ChatUser ChatUser, File file) async {
    //getting image file extention (jpg  or png??)
    final ext = file.path.split(".").last;
    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationId(ChatUser.id.toString())} ${DateTime.now().microsecondsSinceEpoch}.$ext');
    //upload image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
    final imageUrl = await ref.getDownloadURL();
    //uploading image in firestore database
    await sendMessage(ChatUser, imageUrl, Type.image);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  //update isonline status
  static Future<void> updateActiveStatus(bool isOnline) async {
    await firestore.collection('users').doc(user.uid).update({
      "isOnline": isOnline,
      'last_active': DateTime.now().microsecondsSinceEpoch.toString()
    });
  }
}
