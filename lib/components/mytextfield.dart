import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  final String labeltext;
  final int? length;
  final TextEditingController controller;
  final bool obscure;
  final Function(String)? function;
  MyTextField(
      {super.key,
      required this.controller,
      required this.labeltext,
      this.function,
      required this.obscure,  this.length});

  @override
  Widget build(BuildContext context) {
    Brightness currentTheme = Theme.of(context).brightness;
    return TextFormField(
      maxLength: length,
      onChanged: function,
      style: GoogleFonts.titilliumWeb(
          color:
              currentTheme == Brightness.dark ? Colors.white : Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.2),
      obscureText: obscure,
      controller: controller,
      decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: GoogleFonts.titilliumWeb(
              color:
                  currentTheme == Brightness.dark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.2),
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 4),
              borderRadius: BorderRadius.all(Radius.circular(24)))),
    );
  }
}
