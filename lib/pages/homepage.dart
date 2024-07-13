import 'package:chat_app/Database/cloud_database.dart';
import 'package:chat_app/Get/controller.dart';
import 'package:chat_app/components/myUsercard.dart';

import 'package:chat_app/models/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GetController controller = Get.put(GetController());
  List<ChatUser> _list = [];
  List _searchList = [];
  bool isSearching = false;
  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentTheme = Theme.of(context).brightness;
    return WillPopScope(
      onWillPop: (){
        if(isSearching){
          toggleSearch();
          return Future.value(false);
        }else{
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: isSearching
            ? AppBar(
                leading: IconButton(
                    onPressed: () {
                      toggleSearch();
                    },
                    icon: Icon(CupertinoIcons.back,
                    color: currentTheme == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                    )),
                // actions: [
                //   IconButton(
                //       onPressed: () {
                //         toggleSearch();
                //       },
                //       icon: Icon(!isSearching ?CupertinoIcons.search:Icons.cancel_rounded))
                // ],
                title: TextFormField(
                  style: GoogleFonts.ubuntu(
                      color: currentTheme == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1.2),
                  onChanged: (val) {
                    _searchList.clear();
                    for (var i in _list) {
                      if (i.name!.toLowerCase().contains(val.toLowerCase()) ||
                          i.email!.toLowerCase().contains(val.toLowerCase())) {
                        _searchList.add(i);
                      }
                      setState(() {
                        _searchList;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: GoogleFonts.ubuntu(
                        color: currentTheme == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1.2),
                  ),
                ),
                backgroundColor: currentTheme == Brightness.dark
                    ? Colors.black
                    : Colors.amberAccent,
              )
            : null,
        floatingActionButton: isSearching
            ? null
            : FloatingActionButton(
                onPressed: () {
                  toggleSearch();
                },
                backgroundColor: currentTheme == Brightness.dark
                    ? Colors.black
                    : Colors.amberAccent,
                child: Icon(
                  CupertinoIcons.search,
                  color: Theme.of(context).colorScheme.inversePrimary,
                )),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: StreamBuilder(
          //retrieving data from collections => users
          stream: CloudFirestore.getUsersData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Lottie.asset(
                'assets/animations/going.json',
                height: 200,
              )); // Show a loading indicator while waiting for data.
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == null) {
              return Center(child: Text('No Data'));
            }
            final data = snapshot.data?.docs;
            // print((data));
            // for (var i in data) {
            //   print(jsonEncode(i.data()));
            // }
            _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
    
            if (_list.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount:isSearching ? _searchList.length: _list.length,
                            itemBuilder: (context, index) {
                              return UserCard(user:isSearching? _searchList[index]: _list[index]);
                            }),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/animations/waitingforuser.json',
                        height: 200),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "No User Found...\nAdd some Friends!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
