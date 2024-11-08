import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/date_util.dart';
import 'package:chat_app/components/mytextfield.dart';
import 'package:chat_app/models/model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Database/cloud_database.dart';
import '../Get/controller.dart';

class UserProfilePage extends StatefulWidget {
  ChatUser user;
  UserProfilePage({super.key, required this.user});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final GetController controller = Get.put<GetController>(GetController());

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.25),
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width * 0.5,
                          fit: BoxFit.cover,
                          imageUrl: widget.user.image ?? "",
                          placeholder: (context, url) =>
                              Image.asset('assets/images/user(1).png'),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/profile.png'),
                        ),
                      ),
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
                          widget.user.name.toString(),
                          maxLines: null,
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
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
                          widget.user.about.toString(),
                          maxLines: null,
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
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
                          widget.user.email.toString(),
                          maxLines: null,
                          style: GoogleFonts.titilliumWeb(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    Text(MyDateUtils.getLastMessageTime(
                        context: context,
                        time: widget.user.createdAt.toString(),
                        showYear: true))
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
