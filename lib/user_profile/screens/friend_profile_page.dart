import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/user_profile/screens/friend_invite_page.dart';
import 'package:my_app/user_profile/utils/friend_action_widget.dart';
import 'package:my_app/user_profile/utils/other_profile_widget.dart';
import 'package:my_app/user_profile/utils/strangers_action_widget.dart';
import 'package:my_app/user_profile/utils/profile_widget.dart';
import 'package:my_app/user_profile/data/user.dart';
import '../utils/appbar_widget.dart';
import '../utils/friends_display_widget.dart';

//friendprofilepage
class FriendProfilePage extends StatefulWidget {
  final UserData u;
  FriendProfilePage({Key? key, required this.u}) : super(key: key);

  @override
  _FriendProfilePageState createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  late UserData u;
  late bool isFriends;

  @override
  void initState() {
    this.u = widget.u;
    if (u.friends.contains(FirebaseAuth.instance.currentUser?.email)) {
      isFriends = true;
    } else {
      isFriends = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isFriends == false) {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/not-friends-bg.png"))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: buildAppBar(context),
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                  OtherProfileWidget(
                    imagePath: u.image,
                  ),
                  const SizedBox(height: 24),
                  buildName(u),
                  const SizedBox(height: 24),
                  FriendsDisplayWidget(u.friends, u.points),
                  const SizedBox(height: 24),
                  StrangersActionWidget(u),
                  const SizedBox(height: 18),
                  buildAbout(u),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/friends-bg.png"))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: buildAppBar(context),
            body: Container(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                  OtherProfileWidget(
                    imagePath: u.image,
                  ),
                  const SizedBox(height: 14),
                  buildName(u),
                  const SizedBox(height: 14),
                  FriendsDisplayWidget(u.friends, u.points),
                  const SizedBox(height: 14),
                  FriendsActionWidget(u),
                  const SizedBox(height: 14),
                  buildAbout(u),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget buildAbout(UserData user) => Container(
      padding: EdgeInsets.symmetric(horizontal: 28),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 120,
            child: Text(
              user.about,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle,
            ),
          ),
          Positioned(
              left: 30,
              top: 12,
              child: Container(
                padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                color: Colors.white,
                child: Text(
                  'Bio',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ],
      ));

  // Widget buildAbout(UserData user) => Container(
  //       padding: EdgeInsets.symmetric(horizontal: 48),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // ignore: prefer_const_constructors
  //           Center(
  //             child: const Text('About',
  //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //                 textAlign: TextAlign.center),
  //           ),

  //           const SizedBox(height: 16),
  //           Center(
  //               child: Text(
  //             user.about,
  //             style: TextStyle(
  //                 fontSize: 16,
  //                 height: 1.4,
  //                 background: Paint()
  //                   ..strokeWidth = 30.0
  //                   ..color = Colors.white
  //                   ..style = PaintingStyle.stroke
  //                   ..strokeJoin = StrokeJoin.round),
  //             textAlign: TextAlign.center,
  //           )),
  //         ],
  //       ),
  //     );

  Widget buildName(UserData user) => Column(
        children: [
          Text(
            user.username,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.userid.toString(),
            style: TextStyle(color: Colors.grey),
          )
        ],
      );
}
