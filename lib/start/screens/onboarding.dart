import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:my_app/homepage.dart';
import 'package:my_app/user_profile/screens/profile_page.dart';

const Color _PrimaryColV1 = Color(0x33ffcc5c);
const Color _SecondaryColV1 = Color(0xffE3663E);

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(_createSlide(
        "BROWSE GAMES NEAR YOU EASILY",
        "Use your fingers to navigate the map to check out nearby events. It’s as simple as that!",
        "assets/images/ob1.png"));

    slides.add(_createSlide(
        "FIND GAMES TO JOIN",
        "Don’t you miss playing with friends? Join upcoming games with a few clicks. ",
        "assets/images/ob2.png"));
    slides.add(_createSlide(
        "OR INITIATE YOUR OWN",
        "Not your cup of tea? Start your own event and simply wait for others to join!",
        "assets/images/ob3.png"));
    slides.add(
      _createSlide(
          "PLAY WITH FRIENDS, BOTH OLD AND NEW!",
          "What are you waiting for? Let’s explore and find ourselves some SportBuds!",
          "assets/images/ob4.png"),
    );
  }

  //helper function to create Slide
  Slide _createSlide(
      String _title, String _description, String _backgroundImage) {
    return Slide(
      title: _title,
      description: _description,
      backgroundImage: _backgroundImage,
      backgroundImageFit: BoxFit.fitWidth,
      backgroundOpacity: 0.0,
      styleTitle: myTitleStyle(),
      styleDescription: myDescStyle(),
    );
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
    //print(index);
  }

  void onDonePress() {
    // Do what you want
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => Homepage(),
      ),
      ModalRoute.withName('/'),
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: _SecondaryColV1,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: _SecondaryColV1,
    );
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: _SecondaryColV1,
      size: 35.0,
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(_PrimaryColV1),
      overlayColor: MaterialStateProperty.all<Color>(_PrimaryColV1),
    );
  }

  TextStyle myTitleStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'RobotoMono',
    );
  }

  TextStyle myDescStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'RobotoMono',
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];

      tabs.add(
        Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(currentSlide.backgroundImage ??=
                    'assets/images/background.png'),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.7),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        currentSlide.title ??= 'missing title',
                        style: currentSlide.styleTitle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        currentSlide.description ??= 'missing description',
                        style: currentSlide.styleDescription,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                )
              ],
            )),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroSlider(
        //slides: this.slides,

        // Skip button
        renderSkipBtn: this.renderSkipBtn(),
        skipButtonStyle: myButtonStyle(),

        // Next button
        renderNextBtn: this.renderNextBtn(),
        nextButtonStyle: myButtonStyle(),

        // Done button
        renderDoneBtn: this.renderDoneBtn(),
        onDonePress: this.onDonePress,
        doneButtonStyle: myButtonStyle(),

        // Dot indicator
        colorDot: Color(0xffffcc5c),
        sizeDot: 13.0,
        typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

        // Tabs
        listCustomTabs: this.renderListCustomTabs(),
        backgroundColorAllSlides: Colors.white,

        // Behavior
        scrollPhysics: BouncingScrollPhysics(),

        // Show or hide status bar
        hideStatusBar: true,

        // On tab change completed
        onTabChangeCompleted: this.onTabChangeCompleted,
      ),
    );
  }
}
