import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        background: Colors.grey.shade900,
        primary: Colors.grey.shade600,
        secondary: Colors.grey.shade700,
        inversePrimary: Colors.grey.shade300),
    textTheme: ThemeData.dark()
        .textTheme
        .apply(bodyColor: Colors.grey.shade800, displayColor: Colors.black));
