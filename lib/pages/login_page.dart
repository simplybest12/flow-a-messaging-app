import 'package:chat_app/auth/FirebaseAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../components/mytextfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Color? textFieldColor;

  void login() async {
    Get.dialog(Center(
        child: Lottie.asset(
      'assets/animations/going.json',
      height: 200,
    )));
    if (email.text == "" || password.text == "") {
      Get.snackbar("Missing something?", "Filling all fields is mandatory!");
      Navigator.pop(context);
    } else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.text, password: password.text);

        if (context.mounted) Navigator.pop(context);

        Navigator.pushNamedAndRemoveUntil(context, '/tabbar', (route) => false);
      } on FirebaseAuthException catch (e) {
        Get.snackbar("Error", e.toString());
        Navigator.pop(context);
      }
    }
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access the theme here and set textFieldColor based on theme
    textFieldColor = Theme.of(context).colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentTheme = Theme.of(context).brightness;
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
                  'assets/images/login.jpg',
                ),
                Positioned.fill(
                  child: Container(
                    height: 100,
                    color: Colors.white.withOpacity(0.2),
                  ),
                )
              ]),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                child: Column(
                  children: [
                    Text(
                      "Login",
                      style: GoogleFonts.ubuntu(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 42,
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account!",
                          style: GoogleFonts.ubuntu(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/signup', (route) => false);
                          },
                          child: Text(
                            "Register with us",
                            style: GoogleFonts.ubuntu(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
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
                          controller: email, labeltext: "", obscure: false),
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
                        child: TextFormField(
                          onChanged: (text) {
                            if (text.length >= 6) {
                              setState(() {
                                textFieldColor = Colors.blue;
                              });
                            } else {
                              setState(() {
                                textFieldColor =
                                    Theme.of(context).colorScheme.secondary;
                              });
                            }
                          },
                          style: GoogleFonts.titilliumWeb(
                              color: currentTheme == Brightness.dark
                                  ? Colors.white
                                  : Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1.2),
                          obscureText: true,
                          controller: password,
                          decoration: InputDecoration(
                              labelText: "",
                              labelStyle: GoogleFonts.titilliumWeb(
                                  color: currentTheme == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 1.2),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 4),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)))),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "                   or sign in with...",
                          style: GoogleFonts.ubuntu(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 45,
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseAuthorization()
                                  .handleGoogleSignInButton(context);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              padding: EdgeInsets.all(10),
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                            ),
                            child: Image.asset(
                              'assets/images/google (1).png',
                              height: 50,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              padding: EdgeInsets.all(10),
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                            ),
                            child: Image.asset(
                              'assets/images/github (1).png',
                              height: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 75,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (password.text.length >= 6) {
                          login();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            color: textFieldColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              "Continue".toUpperCase(),
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
