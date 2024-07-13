import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
        Brightness currentTheme = Theme.of(context).brightness;
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            "Get in touch",
            style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.inversePrimary,
                letterSpacing: 1.2),
          ),
          elevation: 0,
          backgroundColor: currentTheme == Brightness.dark
              ? Colors.black
              : Colors.amberAccent,
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          
          children: [
          Center(
            child: Text("We will love to hear from you.\nOur friendly team is always here",
            textAlign: TextAlign.center,
            style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary
            ),
            ),
          ),
          SizedBox(height: 50,),
           TextButton(
                  onPressed: () {
                    //logic  goes here
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone, color: Color(0xFFED92A2)),
                      SizedBox(width: 20.0),
                      Text('+91 799 209 8246',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //logic  goes here
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sms, color: Color(0xFFED92A2)),
                      SizedBox(width: 20.0),
                      Text('+0123 4567 8910',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //logic  goes here
                  },
                  style: TextButton.styleFrom(
                    padding:  EdgeInsets.all(15),
                  ),
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.mail, color: Color(0xFFED92A2)),
                      SizedBox(width: 20.0),
                      Text('example@logrocket.com',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //logic  goes here
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_pin, color: Color(0xFFED92A2)),
                      SizedBox(width: 20.0),
                      Text('Gate no.:1 , JSS Noida, ... Sector 62',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //logic  goes here
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.language, color: Color(0xFFED92A2)),
                      SizedBox(width: 20.0),
                      Text('blog.flow.com',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
        ],),
      ),
      
    );
  }
}