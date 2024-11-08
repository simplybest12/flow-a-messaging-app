import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Database/cloud_database.dart';
import 'package:chat_app/components/date_util.dart';
import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/chat.dart';
import 'dialog_box.dart';

class UserCard extends StatefulWidget {
  final ChatUser user;
  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  ChatModel? _message;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12)),
        child: StreamBuilder(
            stream: CloudFirestore.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatModel.fromJson(e.data())).toList();
              if (list != null && list.isNotEmpty) _message = list[0];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Chat_Page(user: widget.user);
                      },
                    ),
                  );
                },
                leading: InkWell(
                  onTap: () {
                    showDialog(
                        context: context, builder: (_) => ProfileDialog(user: widget.user));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * 0.3),
                    child: CachedNetworkImage(
                      height: MediaQuery.of(context).size.height * 0.055,
                      width: MediaQuery.of(context).size.height * 0.055,
                      imageUrl:
                          widget.user.image ?? "assets/images/user(1).png",
                      placeholder: (context, url) =>
                          Image.asset('assets/images/user(1).png'),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/profile.png'),
                    ),
                  ),
                ),
                // const CircleAvatar(
                //     radius: 24,
                //     backgroundImage: AssetImage('assets/images/user(1).png')),
                title: Text(
                  widget.user.name.toString(),
                  maxLines: 1,
                  style: GoogleFonts.titilliumWeb(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                subtitle: Text(
                  _message != null
                      ? (_message!.type == Type.text
                          ? _message!.msg.toString()
                          : "Image")
                      : widget.user.about.toString(),
                  maxLines: 1,
                  style: GoogleFonts.titilliumWeb(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12),
                ),
                trailing: _message == null
                    ? null //show nothing when no message is sent
                    : _message!.read.isEmpty &&
                            _message!.fromId != CloudFirestore.user.uid
                        ?
                        //show for unread message
                        const SizedBox(
                            width: 15,
                            height: 15,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 0, 230, 119),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          )
                        :
                        //message sent time
                        Text(
                            MyDateUtils.getLastMessageTime(
                                context: context,
                                time: _message!.sent.toString()),
                            style: const TextStyle(color: Colors.black54),
                          ),
              );
            }));
  }
}
