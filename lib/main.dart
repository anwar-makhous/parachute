import 'package:flutter/material.dart';
import 'package:parachute_delivery/screens/intro_page.dart';
import 'global_state.dart';
import 'package:flutter/services.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Parachute',
      debugShowCheckedModeBanner: false,
      color: GlobalState.logoColor,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: GlobalState.logoColor)),
      home: const IntroPage(),
    );
  }
}
