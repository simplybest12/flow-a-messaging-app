import 'package:chat_app/Database/cloud_database.dart';
import 'package:chat_app/components/mytextfield.dart';
import 'package:chat_app/pages/profile_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController cnfpasswordcontroller = TextEditingController();
  void GoToProfileImageProfile() async {
    if (cnfpasswordcontroller.text == "" ||
        passwordcontroller.text == "" ||
        emailcontroller.text == "" ||
        emailcontroller.text.contains("@gmail.com")) {
      Get.snackbar("Left any field!", "No Fields must be empty.");
    }
    if (cnfpasswordcontroller.text != passwordcontroller.text) {
      Get.snackbar("Password mismatched", "Both passwords must be same!");
    } else {
      Get.dialog(Center(
          child: Lottie.asset(
        'assets/animations/going.json',
        height: 200,
      )));
      Future.delayed(Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageUsername(
                email: emailcontroller.text, password: passwordcontroller.text),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                Image.asset(
                  'assets/images/signup.jpg',
                ),
                Positioned.fill(
                  child: Container(
                    height: 100,
                    color: Colors.white.withOpacity(0.2),
                  ),
                )
              ]),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                child: Column(
                  children: [
                    Text(
                      "Sign up",
                      style: GoogleFonts.ubuntu(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 42,
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already a member?",
                          style: GoogleFonts.ubuntu(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.ubuntu(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Text(
                          "Email ID :",
                          style: GoogleFonts.ubuntu(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      child: MyTextField(
                          controller: emailcontroller,
                          labeltext: "",
                          obscure: false),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          "Password :",
                          style: GoogleFonts.ubuntu(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      child: MyTextField(
                          controller: passwordcontroller,
                          labeltext: "",
                          obscure: true),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          "Confirm Password :",
                          style: GoogleFonts.ubuntu(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      child: MyTextField(
                          controller: cnfpasswordcontroller,
                          labeltext: "",
                          obscure: true),
                    ),
                    SizedBox(
                      height: 115,
                    ),
                    GestureDetector(
                      onTap: () {
                        print("hello");
                        if (passwordcontroller.text.length >= 6 ||
                            cnfpasswordcontroller.text.length >= 6 &&
                                emailcontroller.text.contains("@gmail.com")) {
                          GoToProfileImageProfile();
                        }
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
                              "NEXT",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
