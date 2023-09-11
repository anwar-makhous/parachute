import 'dart:async';
import "package:flutter/material.dart";
import '../global_state.dart';
import 'HomeScreen/home_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Timer? _timer1;
  Timer? _timer2;
  Timer? _timer3;
  Timer? _timer4;
  double? logoBottomPosition1;
  double? logoLeftPosition2;
  double? logoBottomPosition3;
  bool animationDone = false;

  @override
  void initState() {
    super.initState();
    logoBottomPosition1 = 1000;
    logoLeftPosition2 = -1000;
    logoBottomPosition3 = -1000;
    _timer1 = Timer(const Duration(seconds: 2), () {
      setState(() {
        logoBottomPosition1 = MediaQuery.of(context).size.height * 0.2;
      });
    });
    _timer2 = Timer(const Duration(seconds: 4), () {
      setState(() {
        logoLeftPosition2 = 0;
      });
    });
    _timer3 = Timer(const Duration(seconds: 7), () {
      setState(() {
        logoBottomPosition3 = MediaQuery.of(context).size.height * 0.2;
        animationDone = true;
      });
    });
    _timer4 = Timer(const Duration(seconds: 9), () {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Container(
            color: GlobalState.logoColor,
            child: Stack(children: <Widget>[
              AnimatedPositioned(
                left: 0,
                right: 0,
                bottom: logoBottomPosition1,
                top: 0,
                curve: Curves.slowMiddle,
                duration: const Duration(seconds: 4),
                child: const Center(
                  child: Image(
                    image:
                        AssetImage("assets/logo/Parachute Logo on Red@2x1.png"),
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              AnimatedPositioned(
                left: logoLeftPosition2,
                right: 0,
                bottom: MediaQuery.of(context).size.height * 0.2,
                top: 0,
                curve: Curves.elasticIn,
                duration: const Duration(seconds: 2),
                child: const Center(
                  child: Image(
                    image:
                        AssetImage("assets/logo/Parachute Logo on Red@2x2.png"),
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              AnimatedPositioned(
                left: 0,
                right: 0,
                bottom: logoBottomPosition3,
                top: 0,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(seconds: 2),
                child: const Center(
                  child: Image(
                    image:
                        AssetImage("assets/logo/Parachute Logo on Red@2x3.png"),
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                  bottom: 100,
                  left: 100,
                  right: 100,
                  child: Center(
                      child: (animationDone)
                          ? const CircularProgressIndicator(
                              strokeWidth: 7,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  GlobalState.secondColor),
                            )
                          : Container()))
            ])),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    _timer4?.cancel();
  }
}
