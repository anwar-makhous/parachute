import 'package:flutter/material.dart';
import '/global_state.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChangeEmail();
  }
}

class _ChangeEmail extends State<ChangeEmail> {
  TextEditingController emailController = TextEditingController();
  TextEditingController checkEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool inProgress = false;
  final _formKey = GlobalKey<FormState>();
  bool securePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Change Email",
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
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    newEmailInput(),
                    const SizedBox(
                      height: 20,
                    ),
                    confirmEmailInput(),
                    const SizedBox(
                      height: 20,
                    ),
                    passwordInput(),
                    const SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                  ],
                ),
              ),
            ),
            (inProgress == true)
                ? GlobalState.progressIndicator(context)
                : const Center()
          ],
        ),
      ),
    );
  }

  Widget newEmailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      onChanged: (string) {
        setState(() {});
      },
      decoration: const InputDecoration(
          border: InputBorder.none,
          fillColor: GlobalState.secondColor,
          hintText: "Enter New Email",
          filled: true),
      textInputAction: TextInputAction.next,
      validator: (email) {
        return null;
      
        // return EmailValidator.validate(email) ? null : "Invalid email address";
      },
    );
  }

  Widget confirmEmailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: checkEmailController,
      onChanged: (string) {
        setState(() {});
      },
      decoration: const InputDecoration(
          border: InputBorder.none,
          fillColor: GlobalState.secondColor,
          hintText: "Confirm New Email",
          filled: true),
      textInputAction: TextInputAction.next,
      validator: (password) {
        if (emailController.text.toString() ==
            checkEmailController.text.toString()) {
          return null;
        } else {
          return 'Emails doesn\'t match';
        }
      },
    );
  }

  Widget passwordInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: securePassword,
        controller: passwordController,
        onChanged: (string) {
          setState(() {});
        },
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
        validator: (password) {
          String pattern = r'^([a-zA-Z0-9*.!@$%^&():;<>,?~_+-=]{8,})$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(password!)) {
            return 'Incorrect password';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: (emailController.text != '' &&
              checkEmailController.text != '' &&
              passwordController.text != '')
          ? () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // updateUserEmail(
                //     _emailController.text, _passwordController.text);
              }
            }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(14.0)),
          color: (emailController.text != '' &&
                  checkEmailController.text != '' &&
                  passwordController.text != '')
              ? GlobalState.logoColor
              : GlobalState.logoColor.withOpacity(0.5),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
