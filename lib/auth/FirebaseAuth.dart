// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:chat_app/Database/cloud_database.dart';
import 'package:chat_app/models/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class FirebaseAuthorization {
  FirebaseAuth auth = FirebaseAuth.instance;

  void handleGoogleSignInButton(BuildContext context) {
    Get.dialog(Center(
        child: Lottie.asset(
      'assets/animations/going.json',
      height: 200,
    )));
    try {
      signInWithGoogle().then((user) async {
        if (await CloudFirestore().UserExist()) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else {
          await CloudFirestore.CreateUser();
          Navigator.pushNamedAndRemoveUntil(
              context, '/tabbar', (route) => false);
        }
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
      Navigator.pop(context);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await auth.signInWithCredential(credential);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> signOutcredential(BuildContext context) async {
    // Show a loading animation
    Get.dialog(Center(
      child: Lottie.asset(
        'assets/animations/going.json',
        height: 200,
      ),
    ));

    // Update active status and perform sign-out operations
    await CloudFirestore.updateActiveStatus(false);
    await CloudFirestore.auth.signOut().then((_) async {
      await GoogleSignIn().signOut().then((_) {
        // Close dialog and navigate back to login screen
        Navigator.pop(context);
        Navigator.pop(context);
        //  auth = FirebaseAuth.instance;
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
    });
  }
}
