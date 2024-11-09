import 'dart:developer';
import 'dart:io';

import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CloudFirestore {
  //instance of auhorization
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static User get user => auth.currentUser!;
  // static late ChatUser me;

  //instance of cloud firestorr
  static FirebaseFirestore firebase = FirebaseFirestore.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  //checking user exist or not
    static ChatUser me = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using We Chat!",
      image: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '');


  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });
  }

  Future<bool> UserExist() async {

    return (await firebase.collection('users').doc(auth.currentUser!.uid).get())
        .exists;
  }
static Future<void> getSelfInfo() async {
  try {
    final doc = await firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      me = ChatUser.fromJson(doc.data()!);
      await getFirebaseMessagingToken();

      // Set user status to active
      CloudFirestore.updateActiveStatus(true);
      log('My Data: ${doc.data()}');
    } else {
      await CreateUser();
      // Only call `getSelfInfo` again if user creation was successful
      final newDoc = await firestore.collection('users').doc(user.uid).get();
      if (newDoc.exists) {
        me = ChatUser.fromJson(newDoc.data()!);
        log('User created and retrieved data: ${newDoc.data()}');
      } else {
        log('User creation failed.');
      }
    }
  } catch (e) {
    log('Error in getSelfInfo: $e');
  }
}


  // ignore: non_constant_identifier_names
  static Future<void> CreateUser() async {
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


 static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return firestore
        .collection('users')
        .where('id',
            whereIn: userIds.isEmpty
                ? ['']
                : userIds) //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final userEmail = auth.currentUser!.email;
    // final userEmal = auth.currentUser!.uid;
    // print("current USer Id ");
    // print(userEmal);

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
        log("Not Exist");
        return {};
      }
    } else {
      // Handle case where email is null
      log("Email is null");
      return {};
    }
  }

    static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsersData() {
    // print(auth.currentUser!.email);
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
    static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
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
      log(e.toString());
      Get.snackbar("Error", e.toString());
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  /////////////////NOW HANDLING MESSAGE RELATED DATA /////////////////

  static Stream<QuerySnapshot<Map<String, dynamic>>> getmessageData() {
    return firebase.collection('messages').where('id').snapshots();
  }

  static String getConvId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user) {
    return firebase
        .collection('chats/${getConvId(user.id.toString())}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    log("From Send Message: From: ${user.uid} To: ${chatUser.id}");
    final ChatModel message = ChatModel(
      toId: chatUser.id!,
      read: '',
      fromId: user.uid,
      type: type,
      msg: msg,
      sent: time,
    );

    final ref =
        firebase.collection('chats/${getConvId(chatUser.id!)}/messages');

    try {
      await ref.doc(time).set(message.toJson());
    } catch (e) {
      log("Failed to send message: $e");
    }
  }

  static Future<void> updateMessageReadStatus(ChatModel message) async {
    firestore
        .collection('chats/${getConvId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser chatUser) {
    return firestore
        .collection('chats/${getConvId(chatUser.id!)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConvId(chatUser.id!)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }
    static Future<void> deleteMessage(ChatModel message) async {
    await firestore
        .collection('chats/${getConvId(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  //update message
  static Future<void> updateMessage(ChatModel message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConvId(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }
}
