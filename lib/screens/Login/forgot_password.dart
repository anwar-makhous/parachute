import 'package:flutter/material.dart';
import '../../global_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  bool securePassword = true;
  bool inProgress = false;
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
          title: const Text("Forgot Password"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
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
                            const SizedBox(
                              height: 25,
                            ),
                            emailInput(
                                "Please type you email so we can send you a verification code to reset password"),
                            const SizedBox(
                              height: 20,
                            ),
                            _submitButton(),
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
        ),
      ),
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
            onChanged: (_) {
              setState(() {});
            },
            controller: emailController,
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

  Widget _submitButton() {
    return GestureDetector(
      onTap: (emailController.text != '') ? () async {} : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(14.0)),
          color: (emailController.text != '')
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
