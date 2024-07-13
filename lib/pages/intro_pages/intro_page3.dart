import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
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
                      'assets/animations/authorization.json',
                      height: 300),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Your privacy, our\ntop priority.",
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
