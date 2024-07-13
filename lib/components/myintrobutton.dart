import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroButton extends StatelessWidget {
  final Function function;
  final String text;
  final Color bckColor;
  final Color textColor;

  IntroButton(
      {super.key,
      required this.bckColor,
      required this.function,
      required this.text,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          height: 40,
          width: 65,
          decoration: BoxDecoration(
            color: bckColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.titilliumWeb(
                  fontWeight: FontWeight.bold, color: textColor, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
