//----------------------------------------------------
// UI widgets for the alert dialog of event creation
import 'package:flutter/material.dart';
import 'package:my_app/widgets/bouncing_button.dart';
import 'package:my_app/widgets/hovering_image.dart';

class OkButton extends StatelessWidget {
  const OkButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      bgColor: Colors.white,
      textColor: const Color(0xffD56F2F),
      borderColor: const Color(0xffD56F2F),
      buttonText: "Got it!",
      onClick: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
  }
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
          height: 350,
          decoration: _successBackground,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.22),
                const Text(
                  'Event Created!',
                  style: _titleStyle,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Now all that\'s left is getting fellow SportBuddies to join your event!',
                  style: _paraStyleBold,
                ),
              ],
            ),
          ),
        ),
        actions: [
          const OkButton(),
        ]);
  }
}

class FailDialog extends StatelessWidget {
  const FailDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
          height: 240,
          decoration: _failBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              const Text(
                'Error!',
                style: _titleStyle,
              ),
              const SizedBox(height: 15),
              const Text(
                'Something went wrong. I\'m sorry :(',
                style: _paraStyleBold,
              ),
            ],
          ),
        ),
        actions: [
          const OkButton(),
        ]);
  }
}

const BoxDecoration _successBackground = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('create-event-success.png'),
    fit: BoxFit.fitWidth,
    alignment: Alignment.topCenter,
  ),
);
const BoxDecoration _failBackground = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('create-event-fail.png'),
    fit: BoxFit.fitWidth,
    alignment: Alignment.topCenter,
  ),
);

//Text Styles
const TextStyle _titleStyle = TextStyle(
    fontWeight: FontWeight.bold, fontSize: 45, color: Color(0xffE3663E));

const TextStyle _paraStyleBold = TextStyle(
  color: Colors.black87,
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

///Header holding location details about a sports facility (Place name, Facility Type, Address)
class MapMarkerInfoHeader extends StatelessWidget {
  late String Title; //place name eg. Sun Park
  late String
      Subtitle; //facility type eg. Gym (will be used for place name if place name not available)
  late String Para; //address eg. Street 21 S283710

  MapMarkerInfoHeader(String title, String subtitle, String para, {Key? key})
      : super(key: key) {
    if (title == "") {
      title = subtitle;
      subtitle = "";
    }
    this.Title = title;
    this.Subtitle = subtitle;
    this.Para = para;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    Title,
                    style: _TitleStyle,
                  ),
                  subtitle: Text(
                    Subtitle,
                    style: _subtitleStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    Para,
                    style: _paraStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Text Styles
final _TitleStyle = TextStyle(
  color: Colors.grey[900],
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

final _subtitleStyle = TextStyle(
  color: Colors.grey[900],
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

final _paraStyle = TextStyle(
  color: Colors.grey[900],
  fontSize: 20,
  fontWeight: FontWeight.bold,
);