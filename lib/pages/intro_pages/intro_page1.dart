
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({super.key});

  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
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
                      'assets/animations/Animation - 1699040711738.json',
                      height: 300),
                ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  "Ultimate Platform\nfor seamless\nmessaging.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ubuntu(
                      color: Colors.white,
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
