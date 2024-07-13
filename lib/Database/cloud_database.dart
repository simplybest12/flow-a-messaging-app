import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CloudFirestore {
  //instance of auhorization
  static final auth = FirebaseAuth.instance;
  static final user = FirebaseAuth.instance.currentUser;
  static late ChatUser me;

  //instance of cloud firestorr
  static FirebaseFirestore firebase = FirebaseFirestore.instance;

  //checking user exist or not

  Future<bool> UserExist() async {
    return (await firebase.collection('users').doc(auth.currentUser!.uid).get())
        .exists;
  }

  Future<void> CreateUser() async {
    Get.dialog(Center(
        child: Lottie.asset(
      'assets/animations/going.json',
      height: 200,
    )));
    final time = DateTime.now().microsecondsSinceEpoch;

    final chatUser = ChatUser(
        id: auth.currentUser!.uid,
        email: auth.currentUser!.email!,
        name: auth.currentUser!.displayName,
        image: auth.currentUser!.photoURL ?? '',
        about: "Hey I Am A new Guy",
        createdAt: time.toString(),
        lastActive: time.toString(),
        isOnline: false,
        pushToken: "");

    return await firebase
        .collection('users')
        .doc(auth.currentUser!.email)
        .set(chatUser.toJson());
  }

  // static Future<void> getselfInfo() async {
  //          await FirebaseFirestore
  //         .instance
  //         .collection('users')
  //         .doc(auth.currentUser!.email)
  //         .get().then((value)  async{
  //           if((auth.).emailVerified){
  //             me = UserData.fromJson(auth.currentUser!.data)

  //           }

  //         });
  // }

  static Future<Map<String, dynamic>> getUserData() async {
    final userEmail = auth.currentUser!.email;
    print(userEmail);

    if (userEmail != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userEmail)
          .get();
      // Check if the document exists before returning data
      if (userDoc.exists) {
        return userDoc.data() ?? {};
      } else {
        // Handle case where document doesn't exist
        print("Not Exist");
        return {};
      }
    } else {
      // Handle case where email is null
      print("Email is null");
      return {};
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsersData() {
    print(auth.currentUser!.email);
    return firebase
        .collection('users')
        .where('id', isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  static Future<void> updateName(String nametext, BuildContext context) async {
    Get.dialog(Center(
        child: Lottie.asset(
      'assets/animations/going.json',
      height: 200,
    )));
    try {
      await firebase
          .collection('users')
          .doc(auth.currentUser!.email)
          .update({"name": nametext});
      Navigator.pop(context);
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  static Future<void> updateAbout(
      String abouttext, BuildContext context) async {
    Get.dialog(Center(
        child: Lottie.asset(
      'assets/animations/going.json',
      height: 200,
    )));
    try {
      await firebase
          .collection('users')
          .doc(auth.currentUser!.email)
          .update({"about": abouttext});
      Navigator.pop(context);
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  static Future<void> updateImage(String imageUl, BuildContext context) async {
    Get.dialog(Center(
        child: Lottie.asset(
      'assets/animations/going.json',
      height: 200,
    )));
    try {
      await firebase
          .collection('users')
          .doc(auth.currentUser!.email)
          .update({"image": imageUl});
      Navigator.pop(context);
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  Future<void> deleteUserAccount(BuildContext context) async {
    try {
      await firebase.collection('users').doc(auth.currentUser!.email).delete();
      await FirebaseAuth.instance.currentUser!.delete();

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } on FirebaseAuthException catch (e) {
      print(e);

      if (e.code == "requires-recent-login") {
        await reauthenticateAndDelete();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());

      // Handle general exception
    }
  }

  Future<void> reauthenticateAndDelete() async {
    try {
      final providerData = auth.currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await auth.currentUser!.reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await auth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await auth.currentUser?.delete();
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
    }
  }

  /////////////////NOW HANDLING MESSAGE RELATED DATA /////////////////

  static Stream<QuerySnapshot<Map<String, dynamic>>> getmessageData() {
    print(auth.currentUser!.email);
    return firebase.collection('messages').where('id').snapshots();
  }

  // chats (collection) --> conv_id(doc) --> messages(collection) -->message(doc)
  static String getConvId(String id) => user!.uid.hashCode <= id.hashCode
      ? '${user!.uid}_$id'
      : '${id}_${user!.uid}';

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user) {
    return firebase
        .collection('chats/${getConvId(user.id.toString())}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(String receiverid, String msg) async {
    print("From id : ${user!.uid}");
    print("To id : ${receiverid}");
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final ChatModel message = ChatModel(
        toId: receiverid,
        read: '',
        fromId: user!.uid,
        type: Type.text,
        msg: msg,
        sent: time);

    final ref = firebase.collection('chats/${getConvId(user!.uid)}/messages');
    await ref.doc(time).set(message.toJson());
  }
}
