import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parachute_delivery/data/shops.dart';
import 'models/user.dart';

class GlobalState {
  static const Color logoColor = Color(0xffc30101);
  static const Color secondColor = Color(0xffcccccc);
  static const List<Color> logoGradient = [
    Color(0xffcccccc),
    Color(0xffCA9A9A),
    Color(0xffC86767),
    Color(0xffC63434),
    Color(0xffc30101)
  ];
  static const List<IconData> satisfactionIcons = [
    FontAwesomeIcons.solidFrown,
    FontAwesomeIcons.solidMeh,
    FontAwesomeIcons.solidSmileBeam,
    FontAwesomeIcons.solidGrinAlt,
    FontAwesomeIcons.solidGrinHearts
  ];
  static bool loggedIn = false;
  //User for testing
  static User thisUser = User(
      firstName: "Anwar",
      lastName: "Makhous",
      email: "anwar.ma131313@gmail.com",
      phone: "+963992204711",
      token: "token",
      lat: 35.10,
      long: 34.06,
      address: "Lattakia, Martaqla");
  static String address = "Lattakia, Martaqla";
  static double lat = 35.10;
  static double long = 34.06;
  static List categoriesList = Shops.shops;
  static List reservationsList = [
    {
      "id": 0,
      "shop_id": 0,
      "date": "2021-02-07 15:30",
      "created_at": "2021-01-10 11:30",
      "People#": 2,
      "status": "accepted",
    },
    {
      "id": 2,
      "shop_id": 0,
      "date": "2021-01-22 17:30",
      "created_at": "2021-01-10 11:30",
      "People#": 3,
      "status": "canceled",
    },
    {
      "id": 1,
      "shop_id": 1,
      "date": "2021-02-15 18:30",
      "created_at": "2021-01-10 11:30",
      "People#": 4,
      "status": "pending",
    },
  ];

  static Widget rateWithIcon(var rate,
      {Text text = const Text('Rate',
          style: TextStyle(
            fontSize: 16,
            color: secondColor,
          )),
      bool isRow = true}) {
    int index;
    (rate is double) ? index = rate.floor() : index = rate;
    if (rate == 5) index = 4;
    return (isRow)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              text,
              const SizedBox(
                width: 15,
              ),
              Icon(satisfactionIcons[index], color: logoGradient[index]),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(satisfactionIcons[index], color: logoGradient[index]),
              const SizedBox(
                width: 15,
              ),
              text,
            ],
          );
  }

  static Widget rateWithColoredStars(var rate,
      {Text text = const Text('Rate',
          style: TextStyle(
            fontSize: 16,
            color: secondColor,
          )),
      bool isRow = true}) {
    int index;
    (rate is double) ? index = rate.floor() : index = rate;
    if (rate == 5) index = 4;
    return (isRow)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              text,
              const SizedBox(
                width: 15,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    for (int i = 0; i <= index; i++)
                      WidgetSpan(
                        child:
                            Icon(Icons.star, size: 18, color: logoGradient[i]),
                      ),
                  ],
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    for (int i = 0; i <= index; i++)
                      WidgetSpan(
                        child:
                            Icon(Icons.star, size: 18, color: logoGradient[i]),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              text
            ],
          );
  }

  static Widget rateWithBlackStars(var rate) {
    int index;
    (rate is double) ? index = rate.floor() : index = rate;
    if (rate == 5) index = 4;
    return RichText(
      text: TextSpan(
        children: [
          for (int i = 0; i <= index; i++)
            const WidgetSpan(
              child: Icon(Icons.star, size: 18, color: Colors.black),
            ),
        ],
      ),
    );
  }

  static Widget progressIndicator(BuildContext context,
      {bool transparent = true}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: (transparent) ? Colors.transparent : Colors.white,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: GlobalState.secondColor.withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(14.0)),
          ),
          padding: const EdgeInsets.all(25),
          height: 100,
          width: 100,
          child: const CircularProgressIndicator(
            strokeWidth: 7,
          ),
        ),
      ),
    );
  }

  static Widget parachuteIcon(
      {double size = 24, required void Function() onPress}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            color: logoColor,
            shape: BoxShape.circle,
            border: Border.all(color: logoColor)),
        width: size,
        height: size,
        child: Image.asset(
          'assets/logo/Parachute Logo on Red@2x c only Circular.png',
        ),
      ),
      onTap: onPress,
    );
  }

  static void alert(BuildContext context,
      {required void Function() onConfirm,
      required void Function() onCancel,
      String title = 'Title',
      String message = 'Message',
      bool confirmOnly = false,
      String confirmText = 'Yes',
      String cancelText = 'No'}) {
    Widget confirmButton = TextButton(
        onPressed: onConfirm,
        child: Text(confirmText, style: const TextStyle(color: logoColor)));

    Widget cancelButton = TextButton(
        onPressed: onCancel,
        child: Text(cancelText, style: const TextStyle(color: secondColor)));

    AlertDialog alert = AlertDialog(
      title: Text(
        title,
        style: const TextStyle(color: GlobalState.logoColor),
      ),
      content: Text(message, style: const TextStyle(color: secondColor)),
      actions: [confirmButton, if (!confirmOnly) cancelButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Map getShopByID(int id) {
    Map result = {};
    for (int i = 0; i < categoriesList.length; i++) {
      for (int j = 0; j < categoriesList[i]['shops'].length; j++) {
        if (categoriesList[i]['shops'][j]['id'] == id) {
          result = categoriesList[i]['shops'][j];
          return result;
        }
      }
    }
    return result;
  }

  static Widget reservationStatusIcon(String status, {double size = 24.0}) {
    return Icon(
      (status.toLowerCase() == "pending")
          ? Icons.pending
          : (status.toLowerCase() == "accepted")
              ? Icons.done
              : FontAwesomeIcons.times,
      color: (status.toLowerCase() == "pending")
          ? GlobalState.secondColor
          : (status.toLowerCase() == "accepted")
              ? Colors.green
              : GlobalState.logoColor,
      size: size,
    );
  }

  static Widget parachuteLogoLoading(BuildContext context, bool _inProgress,
      {String headerText = 'Sending your request...',
      Color containerBackgroundColor = Colors.white,
      Color backgroundColor = GlobalState.secondColor,
      Color progressColor = GlobalState.logoColor}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: containerBackgroundColor,
      child: Center(
        child: CircularPercentIndicator(
          radius: MediaQuery.of(context).size.width * 0.66,
          animation: _inProgress,
          animationDuration: 500,
          lineWidth: 15.0,
          percent: 1,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: GlobalState.secondColor,
          progressColor: GlobalState.logoColor,
          header: Text(
            headerText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          center: Padding(
            padding: const EdgeInsets.all(14),
            child: Image.asset(
                'assets/logo/Parachute Logo Icon@2x - CircularLogoColor.png'),
          ),
          restartAnimation: true,
        ),
      ),
    );
  }
}
