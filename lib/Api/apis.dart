import 'package:chatapp/Models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

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
}
