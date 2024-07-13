import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Database/cloud_database.dart';
import 'package:chat_app/Get/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GetController controller = Get.put<GetController>(GetController());
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
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
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            "Settings",
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.background,
                  padding: EdgeInsets.all(15),
                  height: 100,
                  child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.4),
                        child: Obx(
                          () => CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.065,
                            width: MediaQuery.of(context).size.height * 0.065,
                            imageUrl: controller.userData['image'] ?? "",
                            placeholder: (context, url) =>
                                Image.asset('assets/images/user(1).png'),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/images/profile.png'),
                          ),
                        ),
                      ),
                      title: Obx(
                        () => Text(
                          controller.userData['name'] ?? "",
                          maxLines: 1,
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      subtitle: Obx(
                        () => Text(
                          controller.userData['about'] ?? "",
                          maxLines: 1,
                          style: GoogleFonts.titilliumWeb(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 13),
                        ),
                      )),
                ),
                Divider(),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/account');
                        },
                        leading: Icon(
                          Icons.key_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          "Account",
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        subtitle: Text(
                          "Delete Account,Logout",
                          maxLines: 1,
                          style: GoogleFonts.titilliumWeb(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 11),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        leading: Icon(
                          CupertinoIcons.profile_circled,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          "Profile",
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        subtitle: Text(
                          "Edit your personal information",
                          maxLines: 1,
                          style: GoogleFonts.titilliumWeb(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 11),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/theme');
                        },
                        leading: Icon(
                          Icons.color_lens,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          "Theme",
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        subtitle: Text(
                          "Theme,wallpapers,app mode",
                          maxLines: 1,
                          style: GoogleFonts.titilliumWeb(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 11),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        leading: Icon(
                          Icons.notifications,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          "Notification",
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        subtitle: Text(
                          "Security Notifications",
                          maxLines: 1,
                          style: GoogleFonts.titilliumWeb(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 11),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/help');
                        },
                        leading: Icon(
                          CupertinoIcons.question_circle,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          "Help",
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        subtitle: Text(
                          "Help center,contact us",
                          maxLines: 1,
                          style: GoogleFonts.titilliumWeb(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 11),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        leading: Icon(
                          CupertinoIcons.group,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          "About us",
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        subtitle: Text(
                          "know about us",
                          maxLines: 1,
                          style: GoogleFonts.titilliumWeb(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 11),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        leading: Icon(
                          CupertinoIcons.question_circle,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          "Invite a friend",
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      " from",
                      style: GoogleFonts.ubuntu(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 11),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/icons/code.png',
                            height: 20,
                          ),
                        ),
                        Text(
                          "Simply Best",
                          style: GoogleFonts.ubuntu(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
