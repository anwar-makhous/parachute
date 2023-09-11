import 'package:flutter/material.dart';
import 'package:parachute_delivery/screens/Login/forgot_password.dart';
import 'register_page.dart';
import '../../global_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool inProgress = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool securePassword = true;
  Size? cardSize;
  Offset? cardPosition;

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
            title: const Text('Login'),
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
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: SizedBox(
                  height: height,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 25,
                              ),
                              _emailPasswordWidget(),
                              const SizedBox(height: 20),
                              _submitButton(),
                              const SizedBox(
                                height: 15,
                              ),
                              _divider(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    _forgotPasswordLabel(),
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
              (inProgress)
                  ? GlobalState.progressIndicator(context)
                  : const Center(),
            ],
          )),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: (emailController.text != '' && passwordController.text != '')
          ? () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // await logIn(emailController.text.toString(),
                //     passwordController.text.toString());
              } else {
                // GlobalState.toastMessage(
                //     "Wrong Information, please check email & password");
              }
            }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(14.0)),
          color: (emailController.text != '' && passwordController.text != '')
              ? GlobalState.logoColor
              : GlobalState.logoColor.withOpacity(0.5),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
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

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RegisterPage()));
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

  Widget _forgotPasswordLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ForgotPasswordPage()));
      },
      child: Container(
          alignment: Alignment.bottomCenter,
          child: Text('Forgot Password ?',
              style: TextStyle(
                  color: GlobalState.logoColor.withOpacity(0.6),
                  fontSize: 15,
                  fontWeight: FontWeight.bold))),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        emailInput("Email"),
        const SizedBox(
          height: 10,
        ),
        passwordInput("Password"),
      ],
    );
  }

  Widget emailInput(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            onChanged: (_) {
              setState(() {});
            },
            decoration: const InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                hintText: "e.g abc@gmail.com",
                filled: true),
            textInputAction: TextInputAction.next,
            validator: (email) =>
                // EmailValidator.validate(email) ? null : "Invalid email address",
                null,
          ),
        ],
      ),
    );
  }

  Widget passwordInput(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
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
                        ? const Icon(
                            Icons.lock,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.lock,
                            color: GlobalState.logoColor,
                          ))),
            textInputAction: TextInputAction.done,
            onChanged: (_) {
              setState(() {});
            },
            validator: (password) {
              if (passwordController.text.toString().isEmpty) {
                return 'Please enter password';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }
}
