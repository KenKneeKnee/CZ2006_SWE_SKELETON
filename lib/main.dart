import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/calendar/calendar.dart';
import 'package:my_app/map/facil_map.dart';
import 'package:my_app/start/screens/login_page.dart';
import 'package:my_app/start/screens/register_page.dart';
import 'package:my_app/start/screens/register_success.dart';
import 'package:my_app/start/screens/welcome_page.dart';
import 'package:my_app/temp_fetchEvents.dart';
import 'firebase_utils/firebase_options.dart';
import 'package:my_app/events/temp_fetchEvents.dart';
import 'package:my_app/events/temp_fetchEvents.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SportBuds());
}

class SportBuds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Authentication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontSize: 24.0,
            ),
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 46.0,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          ),
          bodyText1: TextStyle(fontSize: 18.0),
        ),
      ),
      //For testing pages
      home: bookingPage(),
    );
  }
}
