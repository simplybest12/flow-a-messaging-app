import 'package:chat_app/Get/controller.dart';
import 'package:chat_app/components/myicons.dart';
import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/homepage.dart';
import 'package:chat_app/pages/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/FirebaseAuth.dart';
import '../pages/call_page.dart';

class MyTabBar extends StatelessWidget {
  MyTabBar({super.key});
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    GetController controller = Get.put(GetController());
    Brightness currentTheme = Theme.of(context).brightness;
    print(user!.email);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              "Flow",
              style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  letterSpacing: 1.2),
            ),
            elevation: 0,
            backgroundColor: currentTheme == Brightness.dark
                ? Colors.black
                : Colors.amberAccent,
            actions: [
              // MyIcon(icon: Image.asset('assets/icons/search.png')),
              // MyIcon(icon: Image.asset('assets/icons/setting-lines.png')),
     
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                  icon: Icon(
                    CupertinoIcons.layers_fill,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  )),
              IconButton(
                  onPressed: () {
                    FirebaseAuthorization().signOutcredential(context);
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  )),
            ]),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Container(
                height: 60,
                color: currentTheme == Brightness.dark
                    ? Colors.black
                    : Colors.amberAccent,
                child: TabBar(
                  labelColor: currentTheme == Brightness.dark
                      ? Colors.amberAccent
                      : Theme.of(context).colorScheme.inversePrimary,
                  unselectedLabelStyle: GoogleFonts.josefinSans(fontSize: 15),
                  labelStyle: GoogleFonts.josefinSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1),
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    const Tab(
                      text: "Chats",
                    ),
                    const Tab(
                      text: "Calls",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    HomePage(),
                    CallPage(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
