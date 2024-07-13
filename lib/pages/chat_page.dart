import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Database/cloud_database.dart';
import 'package:chat_app/components/message_card.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/userprofilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Chat_Page extends StatefulWidget {
  final ChatUser user;
  const Chat_Page({super.key, required this.user});

  @override
  State<Chat_Page> createState() => _Chat_PageState();
}

class _Chat_PageState extends State<Chat_Page> {
  TextEditingController messagecontroller = TextEditingController();
  List<ChatModel> _list = [];

  Widget _appBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: ( (context) => UserProfilePage(user: widget.user))));
      },
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.back,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              // Ss
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.25),
                child: CachedNetworkImage(
                  height: MediaQuery.of(context).size.height * 0.045,
                  width: MediaQuery.of(context).size.height * 0.045,
                  imageUrl: widget.user.image!,
                  placeholder: (context, url) =>
                      Image.asset('assets/images/user(1).png'),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/profile.png'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    widget.user.name.toString(),
                    maxLines: 1,
                    style: GoogleFonts.titilliumWeb(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  Text(
                    widget.user.lastActive.toString(),
                    maxLines: 1,
                    style: GoogleFonts.titilliumWeb(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _myChat(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, right: 0, top: 8),
      child: Row(
        children: [
          Expanded(
            flex: 12,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: messagecontroller,
                      maxLines: null,
                      style: GoogleFonts.ubuntu(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: 1.2),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type any message...",
                        hintStyle: GoogleFonts.ubuntu(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.photo,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.camera,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (messagecontroller.text.isNotEmpty) {
                CloudFirestore.sendMessage(
                    widget.user.id.toString(), messagecontroller.text);
                messagecontroller.clear();
              }
            },
            minWidth: 0,
            shape: CircleBorder(),
            padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
            child: Icon(
              Icons.send_rounded,
              color: Colors.amber,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentTheme = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.call,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
        backgroundColor:
            currentTheme == Brightness.dark ? Colors.black : Colors.amberAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              //retrieving data from collections => users
              stream: CloudFirestore().getAllMessages(widget.user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                  // Show a loading indicator while waiting for data.
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No messages found"));
                } else if (snapshot.data == null) {
                  return Center(
                      child: Lottie.asset('assets/animations/sayhii.json',
                          height: 200));
                }
                final data = snapshot.data?.docs;
                print("Data ${jsonEncode(data![0].data())}");
                _list =
                    data?.map((e) => ChatModel.fromJson(e.data())).toList() ??
                        [];
                print(_list);

                if (_list.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: _list.length,
                                itemBuilder: (context, index) {
                                  return MessageCard(message: _list[index]);
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
                        Lottie.asset('assets/animations/sayhii.json',
                            height: 200),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Say hii!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          _myChat(context),
        ],
      ),
    );
  }
}
