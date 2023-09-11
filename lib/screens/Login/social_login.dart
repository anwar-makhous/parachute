import 'package:flutter/material.dart';
import '../../global_state.dart';
import 'login_page.dart';

class SocialLogin extends StatefulWidget {
  const SocialLogin({Key? key}) : super(key: key);

  @override
  _SocialLoginState createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      top: true,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Login",
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            toolbarTextStyle: const TextTheme(
                titleLarge: TextStyle(
              color: Colors.black,
              fontSize: 18,
            )).bodyMedium,
            titleTextStyle: const TextTheme(
                titleLarge: TextStyle(
              color: Colors.black,
              fontSize: 18,
            )).titleLarge,
          ),
          body: Form(
            key: _formKey,
            child: SizedBox(
              height: height,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: height * .05),
                          Image.asset("assets/logo/Parachute-Logo-on-White.png",
                              width: MediaQuery.of(context).size.width),
                          SizedBox(height: height * .05),
                          const Text(
                            "Login or create an account",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: height * .05),
                          authButton(context),
                          _divider(),
                          authButton(context, type: "Google"),
                          _divider(),
                          authButton(context, type: "Facebook"),
                          _divider(),
                          authButton(context, type: "Apple"),
                          SizedBox(height: height * .15),
                          //  _createAccountLabel(),
                        ],
                      ),
                    ),
                  ),
//            Positioned(top: 40, left: 0, child: _backButton()),
                ],
              ),
            ),
          )),
    );
  }

  SizedBox authButton(BuildContext context, {String type = 'Email'}) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: () {
            if (type == "Email") {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LoginPage();
              }));
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              (type == 'Email')
                  ? const Icon(
                      Icons.email,
                      size: 35,
                      color: GlobalState.logoColor,
                    )
                  : type == 'Facebook'
                      ? SizedBox(
                          height: 45,
                          child: Image.asset("assets/logo/Facebook.png"))
                      : type == 'Google'
                          ? SizedBox(
                              height: 30,
                              child: Image.asset("assets/logo/Google.png"))
                          : SizedBox(
                              height: 40,
                              child: Image.asset("assets/logo/Apple.png")),
              // const SizedBox(
              //   width: 15,
              // ),
              Text(
                type == 'Email'
                    ? "Continue with Email"
                    : type == 'Facebook'
                        ? "Continue with Facebook"
                        : type == 'Google'
                            ? "Continue with Google"
                            : "Continue with Apple",
                style: const TextStyle(fontSize: 18, color: Colors.black),
              )
            ],
          ),
        ));
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
