import 'package:flutter/material.dart';

class MyIcon extends StatelessWidget {
  final Image icon;
  const MyIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: icon,
      height: 20,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary
      ),
    );
  }
}
