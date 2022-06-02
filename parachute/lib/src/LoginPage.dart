import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:parachute/src/RegisterPage.dart';
import '../GlobalState.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../HomePage.dart';
import '../User.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User _user;
  bool _inProgress = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool securePassword = true;
  Size cardSize;
  Offset cardPosition;

  Future<User> logIn(String email, String password) async {
    setState(() {
      _inProgress = true;
    });
    final String logInURL = "${GlobalState.hostURL}/api/auth/login";
    final String getUserInfoURL = "${GlobalState.hostURL}/api/auth/user";
    final response1 =
        await http.post(logInURL, body: {"email": email, "password": password});
    if (response1.statusCode == 200) {
      final Map tokenResponse = json.decode(response1.body);
      String token = tokenResponse['success']['token'];
      final response2 = await http.get(
        getUserInfoURL,
        headers: {'Authorization': 'Bearer $token'},
      );
      final Map _userInfo = json.decode(response2.body);
      setState(() {
        _user = User.fromJson({
          "first_name": _userInfo['success']['first_name'],
          "last_name": _userInfo['success']['last_name'],
          "email": _userInfo['success']['email'],
          "phone": _userInfo['success']['phone'],
          "token": token,
          "lat": GlobalState.lat,
          "long": GlobalState.long,
          "address": GlobalState.address,
        });
        GlobalState.logIn(_user);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false);
      });
      setState(() {
        _inProgress = false;
      });
      return _user;
    } else {
      GlobalState.toastMessage(json.decode(response1.body).toString());
      setState(() {
        _inProgress = false;
      });
      return null;
    }
  }

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
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text('Login'),
            toolbarTextStyle: TextTheme(
                headline6: TextStyle(
              color: Colors.black,
              fontSize: 18,
            )).bodyText2,
            titleTextStyle: TextTheme(
                headline6: TextStyle(
              color: Colors.black,
              fontSize: 18,
            )).headline6,
          ),
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: Container(
                  height: height,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 25,
                              ),
                              _emailPasswordWidget(),
                              SizedBox(height: 20),
                              _submitButton(),
                              SizedBox(
                                height: 15,
                              ),
                              _divider(),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Forgot Password ?',
                                        style: TextStyle(
                                            color: GlobalState.logoColor
                                                .withOpacity(0.6),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    _createAccountLabel(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (_inProgress) ? GlobalState.progressIndicator(context) : Center(),
            ],
          )),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: (emailController.text != '' && passwordController.text != '')
          ? () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                await logIn(emailController.text.toString(),
                    passwordController.text.toString());
              } else {
                GlobalState.toastMessage(
                    "Wrong Information, please check email & password");
              }
            }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
          color: (emailController.text != '' && passwordController.text != '')
              ? GlobalState.logoColor
              : GlobalState.logoColor.withOpacity(0.5),
        ),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
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

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
      },
      child: Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            'Create an account',
            style: TextStyle(
                color: GlobalState.logoColor.withOpacity(0.6),
                fontSize: 15,
                fontWeight: FontWeight.bold),
          )),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        emailInput("Email"),
        SizedBox(
          height: 10,
        ),
        passwordInput("Password"),
      ],
    );
  }

  Widget emailInput(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                hintText: "e.g abc@gmail.com",
                filled: true),
            textInputAction: TextInputAction.next,
            validator: (email) =>
                EmailValidator.validate(email) ? null : "Invalid email address",
          ),
        ],
      ),
    );
  }

  Widget passwordInput(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: securePassword,
            controller: passwordController,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                hintText: "Enter Your Password",
                filled: true,
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        securePassword = !securePassword;
                      });
                    },
                    child: securePassword
                        ? Icon(
                            Icons.lock,
                            color: Colors.black,
                          )
                        : Icon(
                            Icons.lock,
                            color: GlobalState.logoColor,
                          ))),
            textInputAction: TextInputAction.done,
            onChanged: (_) {
              setState(() {});
            },
            validator: (password) {
              if (passwordController.text.toString() == null)
                return 'Please enter password';
              else
                return null;
            },
          ),
        ],
      ),
    );
  }
}