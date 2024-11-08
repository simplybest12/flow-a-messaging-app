import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/userprofilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.36,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, 
                      MaterialPageRoute(builder: (_)=>UserProfilePage(user: user))
                  );
                },
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.25),
                child: CachedNetworkImage(
                  // height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.height * 0.2,
                  imageUrl: user.image ?? "assets/images/user(1).png",
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Image.asset('assets/images/user(1).png'),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/profile.png'),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Text(
                user.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
