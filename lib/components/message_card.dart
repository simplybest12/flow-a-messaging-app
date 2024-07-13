import 'package:chat_app/Database/cloud_database.dart';
import 'package:chat_app/models/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageCard extends StatefulWidget {
  final ChatModel message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    print("This is from id ${widget.message.fromId}");
    print(" this is current user id ${CloudFirestore.user!.uid}");
    return widget.message.fromId == CloudFirestore.user!.uid
        ? _greenMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.035),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: MediaQuery.of(context).size.width * 0.01),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(24)),
              color: Color.fromARGB(255, 181, 230, 252),
            ),
            child: Text(
              widget.message.msg.toString(),
              style: GoogleFonts.ubuntu(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            widget.message.sent.toString(),
            style: GoogleFonts.ubuntu(
              fontSize: 11,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            widget.message.sent.toString(),
            style: GoogleFonts.ubuntu(
              fontSize: 11,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.035),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: MediaQuery.of(context).size.width * 0.01),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(0)),
              color: Colors.amber[100],
            ),
            child: Text(
              widget.message.msg.toString(),
              style: GoogleFonts.ubuntu(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
        ),
      ],
    );
  }
}
