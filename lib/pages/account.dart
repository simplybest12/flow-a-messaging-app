import 'package:chat_app/Database/cloud_database.dart';
import 'package:chat_app/Get/controller.dart';
import 'package:chat_app/auth/FirebaseAuth.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class AccountPage extends StatelessWidget {
  AccountPage({super.key});
  GetController controller = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    Brightness currentTheme = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Account",
          style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.inversePrimary,
              letterSpacing: 1.2),
        ),
        elevation: 0,
        backgroundColor:
            currentTheme == Brightness.dark ? Colors.black : Colors.amberAccent,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ListTile(
                onTap: () {
                  Get.defaultDialog(
                      cancelTextColor: Colors.amber,
                      confirmTextColor: Colors.amber,
                      titlePadding: EdgeInsets.all(10),
                      contentPadding: EdgeInsets.all(30),
                      titleStyle: GoogleFonts.ubuntu(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onConfirm: () {
                        Navigator.pop(context);
                        Get.dialog(Center(
                            child: Lottie.asset(
                          'assets/animations/bye.json',
                          height: 200,
                        )));
                        Future.delayed(Duration(seconds: 4), () {
                          CloudFirestore().deleteUserAccount(context);
                        });
                      },
                      textCancel: "Cancel",
                      textConfirm: "Delete",
                      middleTextStyle: GoogleFonts.ubuntu(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      middleText:
                          "Are you sure you want to\ndelete your account");
                },
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  "Logout",
                  style: GoogleFonts.titilliumWeb(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ListTile(
                onTap: () {
                  FirebaseAuthorization().signOutcredential(context);
                },
                leading: Icon(
                  Icons.logout_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  "Logout",
                  style: GoogleFonts.titilliumWeb(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
