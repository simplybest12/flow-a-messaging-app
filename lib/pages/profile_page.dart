import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/mytextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../Database/cloud_database.dart';
import '../Get/controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GetController controller = Get.put<GetController>(GetController());
  TextEditingController nameedit = TextEditingController();
  TextEditingController aboutedit = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  final _picker = ImagePicker();
  Future<void> updateeditedImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
        try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_images/${user?.email}.jpg');
      await storageReference.putFile(file);
      final image = await storageReference.getDownloadURL();
      
    CloudFirestore.updateImage(image, context);
      
      print("Done");
    } catch (e) {
      print("ERRor:");
      print(e);
    }

  }

  Future<void> fetchUserData() async {
    try {
      // Call your function here
      Map<String, dynamic> data = await CloudFirestore.getUserData();

      // Update the state with the retrieved user data

      controller.addData(data);
    } catch (e) {
      // Handle any errors that may occur during data retrieval
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentTheme = Theme.of(context).brightness;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            "Profile",
            style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.inversePrimary,
                letterSpacing: 1.2),
          ),
          elevation: 0,
          backgroundColor: currentTheme == Brightness.dark
              ? Colors.black
              : Colors.amberAccent,
        ),
        body: ListView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              

                            ),
                            
                            child: Obx(
                              () => CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: controller.userData['image'] ?? "",
                                placeholder: (context, url) =>
                                    Image.asset('assets/images/user(1).png'),
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/images/profile.png'),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: MaterialButton(
                            elevation: 2,
                            height: 100,
                            onPressed: () {
                              updateeditedImage();
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: EdgeInsets.all(12.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        leading: Icon(
                          CupertinoIcons.person_fill,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          "Name:",
                          style: GoogleFonts.ubuntu(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                        subtitle: Text(
                          controller.userData['name'].toString(),
                          maxLines: null,
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 250,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Text(
                                              "Enter the name:",
                                              style: GoogleFonts.ubuntu(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        MyTextField(
                                            length: 20,
                                            controller: nameedit,
                                            labeltext: "",
                                            obscure: false),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  CloudFirestore.updateName(
                                                      nameedit.text, context);
                                                });
                                                nameedit.clear();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Container(
                                                  height: 50,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Update".toUpperCase(),
                                                      style: GoogleFonts
                                                          .titilliumWeb(
                                                              letterSpacing:
                                                                  1.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13),
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
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        leading: Icon(
                          Icons.info_outline_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          "About:",
                          style: GoogleFonts.ubuntu(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                        subtitle: Text(
                          controller.userData['about'].toString(),
                          maxLines: null,
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 250,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Text(
                                              "Enter the about:",
                                              style: GoogleFonts.ubuntu(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        MyTextField(
                                            length: 50,
                                            controller: aboutedit,
                                            labeltext: "",
                                            obscure: false),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  CloudFirestore.updateAbout(
                                                      aboutedit.text, context);
                                                });
                                                nameedit.clear();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Container(
                                                  height: 50,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Update".toUpperCase(),
                                                      style: GoogleFonts
                                                          .titilliumWeb(
                                                              letterSpacing:
                                                                  1.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13),
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
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        leading: Icon(
                          Icons.email_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          "Email id:",
                          style: GoogleFonts.ubuntu(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                        subtitle: Text(
                          controller.userData['email'].toString(),
                          maxLines: null,
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
