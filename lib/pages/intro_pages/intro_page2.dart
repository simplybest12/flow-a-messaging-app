import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatefulWidget {
  const IntroPage2({super.key});

  @override
  State<IntroPage2> createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: Lottie.asset(
                      'assets/animations/Animation - 1699040782894.json',
                      height: 300),
                ),
                SizedBox(
                  height: 80,
                ),
                Text(
                  "Chat from anywhere\nFrom anyone.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ubuntu(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
