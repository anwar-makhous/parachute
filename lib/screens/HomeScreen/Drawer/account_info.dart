import 'package:flutter/material.dart';
import 'change_email.dart';
import '/screens/HomeScreen/home_page.dart';
import '/global_state.dart';

class AccountInfo extends StatefulWidget {
  static bool addressChanged = false;

  const AccountInfo({Key? key}) : super(key: key);

  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  TextEditingController firstNameController =
      TextEditingController(text: GlobalState.thisUser.firstName.toString());
  TextEditingController lastNameController =
      TextEditingController(text: GlobalState.thisUser.lastName.toString());
  TextEditingController phoneNumberController =
      TextEditingController(text: GlobalState.thisUser.phone.toString());
  TextEditingController emailEditingController =
      TextEditingController(text: GlobalState.thisUser.email.toString());
  TextEditingController addressEditingController =
      TextEditingController(text: GlobalState.thisUser.address.toString());
  final _formKey = GlobalKey<FormState>();
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    firstNameController.text = GlobalState.thisUser.firstName;
    lastNameController.text = GlobalState.thisUser.lastName;
    phoneNumberController.text = GlobalState.thisUser.phone;
    addressEditingController.text = GlobalState.thisUser.address;
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
              "Account Info",
            ),
            leading: IconButton(
              iconSize: 30,
              icon: const Icon(Icons.home, color: GlobalState.logoColor),
              tooltip: 'Back to home',
              onPressed: () {
                if (!informationChanged()) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (Route<dynamic> route) => false);
                } else {
                  GlobalState.alert(context,
                      title: 'Warning',
                      message:
                          'Seems like you changed some information but did not '
                          'save your changes, do you want to save changes ?',
                      confirmText: 'Yes, save changes',
                      cancelText: 'No, discard changes', onConfirm: () async {
                    Navigator.pop(context);
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // await updateUserInformation(
                      //     firstNameController.text.toString(),
                      //     lastNameController.text.toString(),
                      //     phoneNumberController.text.toString(),
                      //     addressEditingController.text.toString());
                    }
                  }, onCancel: () {
                    setState(() {
                      inProgress = true;
                    });
                    Navigator.pop(context);
                    // GlobalState.checkLogIn();
                    setState(() {
                      inProgress = false;
                    });
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (Route<dynamic> route) => false);
                  });
                }
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox(
                          height: 15,
                        ),
                        firstName(),
                        const SizedBox(
                          height: 15,
                        ),
                        lastName(),
                        const SizedBox(
                          height: 15,
                        ),
                        phoneInput(),
                        const SizedBox(
                          height: 15,
                        ),
                        addressInput(),
                        const SizedBox(
                          height: 15,
                        ),
                        emailInput(),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: (informationChanged())
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    // await updateUserInformation(
                                    //     firstNameController.text.toString(),
                                    //     lastNameController.text.toString(),
                                    //     phoneNumberController.text.toString(),
                                    //     addressEditingController.text
                                    //         .toString());
                                  }
                                }
                              : null,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(14.0)),
                              color: (informationChanged())
                                  ? GlobalState.logoColor
                                  : GlobalState.logoColor.withOpacity(0.5),
                            ),
                            child: const Text(
                              "Save",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              (inProgress == true)
                  ? GlobalState.progressIndicator(context)
                  : const Center()
            ],
          )),
    );
  }

  bool informationChanged() {
    if (firstNameController.text == GlobalState.thisUser.firstName &&
        lastNameController.text == GlobalState.thisUser.lastName &&
        phoneNumberController.text == GlobalState.thisUser.phone &&
        emailEditingController.text == GlobalState.thisUser.email &&
        !AccountInfo.addressChanged) {
      setState(() {});
      return false;
    } else {
      setState(() {});
      return true;
    }
  }

  Widget firstName() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "First Name ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: firstNameController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: GlobalState.secondColor,
              filled: true,
            ),
            textInputAction: TextInputAction.next,
            onChanged: (string) {
              setState(() {});
            },
            validator: (name) {
              String pattern = r'^[A-Za-z0-9ء-ي]+(?:[ _-][A-Za-z0-9ء-ي]+)*$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(name!)) {
                return 'Invalid first Name';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget lastName() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Last Name ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: lastNameController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: GlobalState.secondColor,
              filled: true,
            ),
            textInputAction: TextInputAction.next,
            onChanged: (string) {
              setState(() {});
            },
            validator: (name) {
              String pattern = r'^[A-Za-z0-9ء-ي]+(?:[ _-][A-Za-z0-9ء-ي]+)*$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(name!)) {
                return 'Invalid Last Name';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget phoneInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Phone Number",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: GlobalState.secondColor,
              filled: true,
            ),
            textInputAction: TextInputAction.done,
            onChanged: (string) {
              setState(() {});
            },
            validator: (name) {
              String pattern = r'^(?:[+0]9)?[0-9]{7,20}$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(name!)) {
                return 'Invalid Phone Number';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget emailInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChangeEmail()));
                      },
                      child: const Text(
                        "Change Email ?",
                        style: TextStyle(
                          fontSize: 15,
                          color: GlobalState.logoColor,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            FocusScope(
              node: FocusScopeNode(),
              child: TextFormField(
                onChanged: (string) {
                  setState(() {});
                },
                enabled: false,
                controller: emailEditingController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: GlobalState.secondColor,
                  filled: true,
                ),
              ),
            )
          ]),
    );
  }

  Widget addressInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Address",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => PlaceLocation.setLocation(
                        //         false,
                        //         LatLng(GlobalState.lat, GlobalState.long))));
                      },
                      child: const Text(
                        "Change Address ?",
                        style: TextStyle(
                          fontSize: 15,
                          color: GlobalState.logoColor,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            FocusScope(
              node: FocusScopeNode(),
              child: TextFormField(
                onChanged: (string) {
                  setState(() {});
                },
                enabled: false,
                controller: addressEditingController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: GlobalState.secondColor,
                  filled: true,
                ),
              ),
            )
          ]),
    );
  }
}
