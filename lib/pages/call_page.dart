

import 'package:chat_app/Database/cloud_database.dart';

import 'package:chat_app/components/myUsercard.dart';
import 'package:chat_app/models/model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
    Brightness currentTheme = Theme.of(context).brightness;
    return Scaffold(
     
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder(
        //retrieving data from collections => users
        stream: CloudFirestore.firebase.collection('usrs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Show a loading indicator while waiting for data.
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(child: Text('No Data'));
          }
          final data = snapshot.data?.docs;
          // print((data));
          // for (var i in data) {
          //   print(jsonEncode(i.data()));
          // }
          list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
          if (list.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return UserCard(user: list[index]);
                          }),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/animations/waitingforuser.json',
                  height: 200
                  ),
                  SizedBox(height: 20,),
                  Text("No User Found...\nAdd some Friends!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ubuntu(
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary
                  ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
