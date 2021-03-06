import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/start/screens/error_page.dart';
import 'package:my_app/user_profile/data/user.dart';
import 'package:my_app/user_profile/data/userDbManager.dart';
import 'package:my_app/user_profile/screens/friend_profile_page.dart';

class Friend_Invite_Page extends StatefulWidget {
  final List<dynamic> friends;
  const Friend_Invite_Page({Key? key, required this.friends}) : super(key: key);
  @override
  _FriendInvitePageState createState() => _FriendInvitePageState();
}

class _FriendInvitePageState extends State<Friend_Invite_Page> {
  final myController = TextEditingController();
  final UserDbManager repository = UserDbManager();
  late List<dynamic> friendData = widget.friends;
  final List<UserData> listfriends = [];
  ScrollController controller = ScrollController();
  final List<Widget> friendbuttons = [];
  double topContainer = 0;
  UserDbManager userdb = UserDbManager();
  late UserData cu;
  getUser() async {
    DocumentSnapshot doc = await userdb.collection
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();
    cu = UserData.fromSnapshot(doc);
  }

  @override
  void initState() {
    getUser();
    super.initState();
    controller.addListener(() {
      double value = controller.offset / 1000;

      setState(() {
        topContainer = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: repository.getStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return SmthWrong();
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          UserData u = UserData.fromSnapshot(snapshot.data!.docs[0]);

          List DocList = snapshot.data!.docs;

          listfriends.clear();
          for (String userid in friendData) {
            for (DocumentSnapshot doc in DocList) {
              if (doc["userid"] == userid) {
                u = UserData.fromSnapshot(doc);
                listfriends.add(u);
              }
            }
          }

          friendbuttons.clear();

          for (UserData u in listfriends) {
            friendbuttons.add(Container(
                height: size.height * 0.2,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(100), blurRadius: 10.0),
                    ]),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                u.username,
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FloatingActionButton.extended(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildDialog(context));
                                  },
                                  label: const Text('Invite'),
                                  backgroundColor: Colors.orange),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Ink.image(
                                image: Image.network(u.image).image,
                                fit: BoxFit.cover,
                                width: 128,
                                height: 128,
                              ),
                            ),
                          )
                        ]))));
          }

          //Appbar kinda of the page
          return SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.deepPurple,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Color.fromRGBO(227, 102, 62, 1),
                    leading: BackButton(
                        color: Colors.black,
                        onPressed: () => Navigator.of(context).pop()),
                  ),
                  body: Container(
                    height: size.height,
                    child: ListView.builder(
                        controller: controller,
                        itemCount: friendbuttons.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          double scale = 1.0;
                          if (topContainer > 0.1) {
                            scale = index + 0.1 - topContainer;
                            if (scale < 0) {
                              scale = 0;
                            } else if (scale > 1) {
                              scale = 1;
                            }
                          }
                          return Opacity(
                            opacity: scale,
                            child: Transform(
                              transform: Matrix4.identity()
                                ..scale(scale, scale),
                              alignment: Alignment.bottomCenter,
                              child: Align(
                                  heightFactor: 0.8,
                                  alignment: Alignment.topCenter,
                                  child: friendbuttons[index]),
                            ),
                          );
                        }),
                  )));
        });
  }

  Widget _buildDialog(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("An invitation has been sent"),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
