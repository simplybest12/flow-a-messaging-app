import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCard extends StatefulWidget {
  final ChatUser user;
  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(12)),
      child: ListTile(
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
        leading: ClipRRect(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.height * 0.3),
          child: CachedNetworkImage(
            height: MediaQuery.of(context).size.height * 0.055,
            width: MediaQuery.of(context).size.height * 0.055,
            imageUrl: widget.user.image!,
            placeholder: (context, url) =>
                Image.asset('assets/images/user(1).png'),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/profile.png'),
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
          widget.user.about.toString(),
          maxLines: 1,
          style: GoogleFonts.titilliumWeb(
              color: Theme.of(context).colorScheme.primary, fontSize: 12),
        ),
        trailing: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.user.createdAt.toString(),
                style: GoogleFonts.titilliumWeb(
                    color: Theme.of(context).colorScheme.primary, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
