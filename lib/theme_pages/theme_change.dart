import 'package:chat_app/Get/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes extends StatelessWidget {
  Themes({super.key});
  GetController controller = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    Brightness currentTheme = Theme.of(context).brightness;
   bool iconbulb = controller.isDarkMode.value;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Theme",
          style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.inversePrimary,
              letterSpacing: 1.2),
        ),
        elevation: 0,
        backgroundColor:
            currentTheme == Brightness.dark ? Colors.black : Colors.amberAccent,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Display",
                style: GoogleFonts.ubuntu(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 13),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ListTile(
                leading: Icon(iconbulb==false?CupertinoIcons.lightbulb_fill:
                  CupertinoIcons.lightbulb,
                  color: Colors.amber,
                ),
                title: Text(
                  "Dark Mode",
                  style: GoogleFonts.titilliumWeb(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                trailing: Obx(
                  () => Switch(
                      activeColor: Colors.amber,
                      value: controller.isDarkMode.value,
                      onChanged: (value) {
                        print(value);
                        controller.toggleTheme();
                      }),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ListTile(
                leading: Icon(
                  Icons.wallpaper_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  "Wallpaper",
                  style: GoogleFonts.titilliumWeb(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),

              ),
            ),
          ],
        ),
      )),
    );
  }
}
