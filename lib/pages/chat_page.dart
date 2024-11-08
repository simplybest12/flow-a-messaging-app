import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Database/cloud_database.dart';
import 'package:chat_app/components/date_util.dart';
import 'package:chat_app/components/message_card.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/userprofilepage.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../Get/emoji.dart';

class Chat_Page extends StatefulWidget {
  final ChatUser user;
  const Chat_Page({super.key, required this.user});

  @override
  State<Chat_Page> createState() => _Chat_PageState();
}

class _Chat_PageState extends State<Chat_Page> {
  TextEditingController textcontroller = TextEditingController();
  List<ChatModel> _list = [];

  // bool _emoji = false;
  final emojitextEditingController = TextEditingController();
  final emojicntrl = Get.put(EmojiController());
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    Brightness currentTheme = Theme.of(context).brightness;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        //if emojis are shown & back button is pressed then hide emojis
        //or else simple close current screen on back button click
        canPop: false,

        onPopInvoked: (_) {
          if (emojicntrl.emoji.value) {
            emojicntrl.changeVisibility(emojicntrl.emoji.value);
            return;
          }

          // some delay before pop
          Future.delayed(const Duration(milliseconds: 300), () {
            try {
              // ignore: use_build_context_synchronously
              if (Navigator.canPop(context)) Navigator.pop(context);
            } catch (e) {
              log('ErrorPop: $e');
            }
          });
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
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
            backgroundColor: currentTheme == Brightness.dark
                ? Colors.black
                : Colors.amberAccent,
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: CloudFirestore().getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container();
                      case ConnectionState.none:
                        return Center(child: Text("No Connection"));
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;

                        // Check if there’s any data in the snapshot
                        if (data == null || data.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/animations/sayhii.json',
                                    height: 200),
                                SizedBox(height: 25),
                                Text(
                                  "Say hii!",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntu(
                                    letterSpacing: 1.4,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Parse the data into a list of ChatModel objects
                        _list = data
                            .map((e) => ChatModel.fromJson(e.data()))
                            .toList();

                        // Render the messages if the list is not empty
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SafeArea(
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    reverse: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: _list.length,
                                    itemBuilder: (context, index) {
                                      return MessageCard(message: _list[index]);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                    }
                  },
                ),
              ),
              if (_isUploading)
                const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: CircularProgressIndicator(strokeWidth: 2))),
              myChat(context),
              if (emojicntrl.emoji.value)
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: EmojiPicker(
                      onBackspacePressed: () {
                        // Do something when the user taps the backspace button (optional)
                        // Set it to null to hide the Backspace-Button
                      },
                      textEditingController:
                          emojitextEditingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        height: 10,
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          emojiSizeMax: 28 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.20
                                  : 1.0),
                        ),
                        viewOrderConfig: const ViewOrderConfig(
                          top: EmojiPickerItem.categoryBar,
                          middle: EmojiPickerItem.emojiView,
                          bottom: EmojiPickerItem.searchBar,
                        ),
                        skinToneConfig: const SkinToneConfig(),
                        categoryViewConfig: const CategoryViewConfig(),
                        bottomActionBarConfig: const BottomActionBarConfig(),
                        searchViewConfig: const SearchViewConfig(),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => UserProfilePage(user: widget.user))));
      },
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          StreamBuilder(
  stream: CloudFirestore.getUserInfo(widget.user),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator(); // Show a loading indicator
    }

    if (snapshot.hasError) {
      return const Text('Error loading data'); // Handle any error that might occur
    }

    final data = snapshot.data?.docs;
    final list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

    return Row(
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
        ClipRRect(
          borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.height * 0.25),
          child: CachedNetworkImage(
            height: MediaQuery.of(context).size.height * 0.045,
            width: MediaQuery.of(context).size.height * 0.045,
            imageUrl: list.isNotEmpty && list[0].image != null
                ? list[0].image!
                : widget.user.image ?? '',
            placeholder: (context, url) =>
                Image.asset('assets/images/user(1).png'),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/profile.png'),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              list.isNotEmpty && list[0].name != null
                  ? list[0].name!
                  : widget.user.name ?? 'Unknown',
              maxLines: 1,
              style: GoogleFonts.titilliumWeb(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              list.isNotEmpty && list[0].isOnline != null
                  ? (list[0].isOnline!
                      ? 'Online'
                      : MyDateUtils.getLastActiveTime(
                          context: context,
                          lastActive: list[0].lastActive ?? DateTime.now().toString(),
                        ))
                  : MyDateUtils.getLastActiveTime(
                      context: context,
                      lastActive: widget.user.lastActive?.toString() ?? DateTime.now().toString(),
                    ),
              maxLines: 1,
              style: GoogleFonts.titilliumWeb(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  },
)

        ],
      ),
    );
  }

  Widget myChat(BuildContext context) {
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
                      onPressed: () {
                        emojicntrl.changeVisibility(emojicntrl.emoji.value);
                        FocusScope.of(context).unfocus();
                      },
                      icon: Obx(
                        () => Icon(
                          Icons.emoji_emotions_outlined,
                          color: emojicntrl.emoji.value
                              ? Colors.blue
                              : Theme.of(context).colorScheme.secondary,
                        ),
                      )),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: textcontroller,
                      maxLines: null,
                      onTap: () {
                        if (emojicntrl.emoji.value) {
                          emojicntrl.changeVisibility(emojicntrl.emoji.value);
                        }
                        FocusScope.of(context).unfocus();
                      },
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
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Picking multiple images
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);

                        // uploading & sending image one by one
                        for (var i in images) {
                          log('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          await CloudFirestore.sendChatImage(
                              widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: Icon(
                        CupertinoIcons.photo,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);

                          await CloudFirestore.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
                        }
                      },
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
              if (textcontroller.text.isNotEmpty) {
                CloudFirestore.sendMessage(
                    widget.user, textcontroller.text, Type.text);
                textcontroller.text = '';
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
}
