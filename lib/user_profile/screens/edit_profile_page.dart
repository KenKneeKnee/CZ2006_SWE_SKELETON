import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/user_profile/data/user.dart';
import 'package:my_app/user_profile/data/userDbManager.dart';
import 'package:my_app/user_profile/utils/profile_widget.dart';
import 'package:my_app/user_profile/utils/progress_widget.dart';
import 'package:my_app/widgets/bouncing_button.dart';

import '../utils/appbar_widget.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  late UserData user;
  bool _displayNameValid = true;
  bool _bioValid = true;
  late final image;

  UserDbManager userdb = UserDbManager();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await userdb.collection
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();
    user = UserData.fromSnapshot(doc);
    displayNameController.text = user.username;
    bioController.text = user.about;
    image = Image.asset(user.image);

    setState(() {
      isLoading = false;
    });
  }

  Column buildField(String title, String hint, TextEditingController controller,
      bool check, String warning) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            )),
        Container(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                errorText: check ? null : warning,
              ),
            ),
          ),
        )
      ],
    );
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      bioController.text.trim().length > 140
          ? _bioValid = false
          : _bioValid = true;
    });

    if (_displayNameValid && _bioValid) {
      userdb.collection.doc(FirebaseAuth.instance.currentUser?.email).update({
        "username": displayNameController.text,
        "about": bioController.text,
      });
      SnackBar snackbar = SnackBar(
        content: Text("Profile updated!"),
        backgroundColor: Color(0xffE3663E),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Color _getTextColor(Set<MaterialState> states) => states.any(<MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      }.contains)
          ? Colors.green
          : Colors.lightGreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: BackButton(
            color: Colors.white, onPressed: () => Navigator.of(context).pop()),
        backgroundColor: Color(0xFF049cac),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? circularProgress()
          : Container(
              color: Color(0xFF049cac),
              child: ListView(
                children: <Widget>[
                  Column(children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom: 28.0,
                        ),
                        child: ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: Ink.image(
                              image: image.image,
                              fit: BoxFit.cover,
                              width: 128,
                              height: 128,
                            ),
                          ),
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(40.0),
                            bottomLeft: Radius.circular(0.0)),
                      ),
                      padding: EdgeInsets.all(36.0),
                      child: Column(
                        children: <Widget>[
                          buildField(
                              "Username",
                              "Change username",
                              displayNameController,
                              _displayNameValid,
                              "Username is too short"),
                          buildField(
                              "About",
                              "Talk about yourself...",
                              bioController,
                              _bioValid,
                              "Bio is too long. Character Count: ${bioController.text.length} / 140"),
                          SizedBox(
                            height: 100,
                          ),
                          ElevatedButton.icon(
                              onPressed: updateProfileData,
                              icon: Icon(Icons.edit),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0),
                                )),
                                backgroundColor: MaterialStateColor.resolveWith(
                                    _getTextColor),
                              ),
                              label: Text(
                                "SAVE",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ])
                ],
              ),
            ),
    );
  }
}
