import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        background: Colors.white,
        primary: Colors.grey.shade700,
        secondary: Colors.grey,
        inversePrimary: Colors.grey.shade800),
    textTheme: ThemeData.light()
        .textTheme
        .apply(bodyColor: Colors.grey.shade800, displayColor: Colors.black));
