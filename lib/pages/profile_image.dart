import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../components/mytextfield.dart';
import '../models/model.dart';

class ImageUsername extends StatefulWidget {
  String? password = "";
  String? email = "";
  ImageUsername({super.key, this.password, this.email});
  @override
  State<ImageUsername> createState() => _ImageUsernameState();
}

class _ImageUsernameState extends State<ImageUsername> {
  TextEditingController userName = TextEditingController();
  TextEditingController about = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  final _picker = ImagePicker();
  File? selectedImage;
  String? ImageUrl;
  User? user = FirebaseAuth.instance.currentUser;

  Future<String?> uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    setState(() {
      selectedImage = file;
    });

    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_images/${user?.email}.jpg');
      await storageReference.putFile(file);
      final image = await storageReference.getDownloadURL();
      ImageUrl = image;

      return ImageUrl;
    } catch (e) {

      print(e);
    }
  }

  void registerUser() async {
    Get.dialog(Center(
        child: Lottie.asset(
      'assets/animations/going.json',
      height: 200,
    )));
    if (userName.text == "" || about.text == "") {
      Navigator.pop(context);
      Get.snackbar("Left any field!", "No Fields must be empty.");
    } else {
      print("Starting");
      print(widget.email.toString());
      try {
        UserCredential? userCredential =
            await auth.createUserWithEmailAndPassword(
                email: widget.email.toString(),
                password: widget.password.toString());
        // ignore: avoid_print
        print("Authorization");
        createUserDocument(userCredential);
        if (context.mounted) Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, '/tabbar', (route) => false);
      } on FirebaseAuthException catch (e) {
        Get.snackbar("Error", e.code);
        Navigator.pop(context);
      } catch (e) {
        Get.snackbar("Error", e.toString());
        Navigator.pop(context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    Get.dialog(Center(
        child: Lottie.asset(
      'assets/animations/going.json',
      height: 200,
    )));
    final time = DateTime.now().microsecondsSinceEpoch;

    print(ImageUrl);

    final chatUser = ChatUser(
        id: auth.currentUser!.uid,
        email: auth.currentUser!.email!,
        name: userName.text,
        image: ImageUrl ?? '',
        about: about.text,
        createdAt: time.toString(),
        lastActive: time.toString(),
        isOnline: false,
        pushToken: "");
    try {
      if (userCredential != null && userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.email)
            .set(chatUser.toJson());
      }
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Widget buildAvatar() {
    if (selectedImage != null) {
      return CircleAvatar(
        radius: 90,
        backgroundImage: FileImage(selectedImage!),
        backgroundColor: Colors.white,
      );
    } else {
      return const CircleAvatar(
        radius: 90,
        backgroundImage: AssetImage('assets/images/user(1).png'),
        backgroundColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      Stack(
                        children: [
                          buildAvatar(),
                          Positioned(
                              bottom: 0,
                              left: 120,
                              child: IconButton(
                                  onPressed: () {
                                    uploadImage();
                                  },
                                  icon: const Icon(Icons.add_a_photo_rounded)))
                        ],
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      MyTextField(
                          controller: userName,
                          labeltext: "Username",
                          length: 15,
                          obscure: false),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                          controller: about,
                          labeltext: "About",
                          length: 50,
                          obscure: false),
                      const SizedBox(
                        height: 155,
                      ),
                      GestureDetector(
                        onTap: () {
                          registerUser();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                "submit".toUpperCase(),
                                style: GoogleFonts.titilliumWeb(
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
