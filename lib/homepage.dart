import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/map/facil_map.dart';
import 'package:my_app/user_profile/screens/profile_page.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);
  User? user = FirebaseAuth.instance.currentUser;

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int pageIndex = 0;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = widget.user!;
    final pages = [
      FacilitiesMap(),
      ProfilePage(user: _currentUser),
    ];

    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: pageIndex,
          onTap: (index) => setState(() {
                pageIndex = index;
              }),
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: 'Map',
                backgroundColor: Colors.blue),
            const BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_outlined),
                label: 'Profile',
                backgroundColor: Colors.purple),
            // const BottomNavigationBarItem(
            //     icon: Icon(Icons.people_alt_outlined),
            //     label: 'Events',
            //     backgroundColor: Colors.yellow),
            // const BottomNavigationBarItem(
            //     icon: Icon(Icons.people_alt_outlined),
            //     label: 'Settings',
            //     backgroundColor: Colors.green),
          ]),
    );
  }
}
