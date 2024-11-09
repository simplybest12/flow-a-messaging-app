import 'dart:developer';
import 'package:chat_app/Database/cloud_database.dart';
import 'package:chat_app/Get/controller.dart';
import 'package:chat_app/components/myUsercard.dart';
import 'package:chat_app/models/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../components/dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GetController controller = Get.put(GetController());
  List<ChatUser> _list = [];
  List<ChatUser> _searchList = []; // Specify the type to avoid issues
  bool isSearching = false;
  void initState() {
    // TODO: implement initState
    super.initState();
    CloudFirestore.getSelfInfo();

    // for updating user active status according to lifecycle events
    // resume -- active or online
    // pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (CloudFirestore.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          CloudFirestore.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          CloudFirestore.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentTheme = Theme.of(context).brightness;

    return WillPopScope(
      onWillPop: () {
        if (isSearching) {
          toggleSearch();
          return Future.value(false);
        } else {
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
                    icon: Icon(
                      CupertinoIcons.back,
                      color: currentTheme == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: TextFormField(
                    style: GoogleFonts.ubuntu(
                      color: currentTheme == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                    onChanged: (val) {
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name!.toLowerCase().contains(val.toLowerCase()) ||
                            i.email!
                                .toLowerCase()
                                .contains(val.toLowerCase())) {
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
                        letterSpacing: 1.2,
                      ),
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
                    // toggleSearch();
                    _addChatUserDialog();
                  },
                  backgroundColor: currentTheme == Brightness.dark
                      ? Colors.black
                      : Colors.amberAccent,
                  child: Icon(
                    CupertinoIcons.search,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          body:  StreamBuilder(
                      stream: CloudFirestore.getUsersData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Lottie.asset(
                              'assets/animations/going.json',
                              height: 200,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.data == null ||
                            snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No Data'));
                        }

                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => ChatUser.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SafeArea(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: isSearching
                                          ? _searchList.length
                                          : _list.length,
                                      itemBuilder: (context, index) {
                                        return UserCard(
                                          user: isSearching
                                              ? _searchList[index]
                                              : _list[index],
                                        );
                                      },
                                    ),
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
                                Lottie.asset(
                                  'assets/animations/waitingforuser.json',
                                  height: 200,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  "No User Found...\nAdd some Friends!",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntu(
                                    letterSpacing: 1.4,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
    
                }
              })),
    );
  }

  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: const InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.trim().isNotEmpty) {
                        await CloudFirestore.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
