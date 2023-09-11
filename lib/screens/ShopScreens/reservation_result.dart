import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/screens/HomeScreen/home_page.dart';
import 'restaurant_reservation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../global_state.dart';

class ReservationResult extends StatefulWidget {
  final Map _reservationInfo;
  final Map _restaurantData;
  final int _reservationID;
  final String status;
  static bool isFromLog = false;

  const ReservationResult(this._reservationInfo, this._restaurantData,
      this.status, this._reservationID,
      {Key? key})
      : super(key: key);

  ReservationResult.fromLog(this._reservationInfo, this._restaurantData,
      this.status, this._reservationID,
      {Key? key})
      : super(key: key) {
    isFromLog = true;
  }

  @override
  _ReservationResultState createState() => _ReservationResultState();
}

class _ReservationResultState extends State<ReservationResult> {
  Map _reservationInfo = {};
  Map restaurantData = {};
  // Map _reservationResponse = {};
  int reservationID = 0;
  String status = '';
  String pendingText = '';
  String confirmText = '';
  String refusedText = '';
  String canceledText = '';
  IconData pendingIcon = const IconData(0);
  IconData confirmIcon = const IconData(0);
  IconData refusedIcon = const IconData(0);
  bool inProgress = false;
  bool gettingShop = false;
  bool canceled = false;
  DateTime date = DateTime(2021);
  String? details;
  int peopleNumber = 0;

  _ReservationResultState();

  @override
  void initState() {
    super.initState();
    _reservationInfo = widget._reservationInfo;
    restaurantData = widget._restaurantData;
    status = widget.status;
    reservationID = widget._reservationID;
    canceled = false;
    pendingText = 'Your request to '
        '${restaurantData['name']} have been sent, '
        'waiting for their response.';
    canceledText = 'You have canceled your reservation request to '
        '${restaurantData['name']} '
        'successfully.';
    refusedText = 'We\'re sorry, looks like '
        '${restaurantData['name']} didn\'t accept '
        'your reservation request, wanna try another place ?';
    confirmText = '${restaurantData['name']} '
        'accepted your reservation request and ready to serve you in time,'
        ' enjoy your meal !';
    pendingIcon = Icons.pending;
    confirmIcon = Icons.done;
    refusedIcon = FontAwesomeIcons.times;
    date = (!ReservationResult.isFromLog)
        ? _reservationInfo['Full Date']
        : DateTime.parse(_reservationInfo['date']);
    details = _reservationInfo['Additional Details'];
    peopleNumber = _reservationInfo['People#'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Stack(children: [
          Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: ReservationResult.isFromLog,
                centerTitle: true,
                title: const Text("Your Reservation Details"),
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
                leading: (!ReservationResult.isFromLog)
                    ? IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.home,
                            color: GlobalState.logoColor),
                        tooltip: 'Back to home',
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (Route<dynamic> route) => false);
                        },
                      )
                    : null,
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
              body: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (!canceled) ? confirmationTile() : cancellationTile(),
                        const Divider(
                          thickness: 2,
                        ),
                        reservationInfoWidget(),
                        SizedBox(
                          height: (canceled)
                              ? MediaQuery.of(context).size.height * 0.10
                              : MediaQuery.of(context).size.height * 0.20,
                        )
                      ],
                    )),
              )),
          Positioned(
            bottom: 5,
            left: 5,
            right: 5,
            child: (status.toLowerCase() == 'declined' || canceled == true)
                ? refusedButton()
                : actionButtons(context),
          ),
          (inProgress)
              ? GlobalState.parachuteLogoLoading(context, inProgress,
                  headerText: 'Sending your reservation request...')
              : Container(),
          (gettingShop)
              ? GlobalState.progressIndicator(context, transparent: false)
              : Container()
        ]));
  }

  Widget confirmationTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .75,
          child: Text(
            (status.toLowerCase() == "pending")
                ? pendingText
                : (status.toLowerCase() == 'accepted')
                    ? confirmText
                    : refusedText,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        GlobalState.reservationStatusIcon(status, size: 40),
      ],
    );
  }

  Widget cancellationTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .75,
          child: Text(
            canceledText,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Icon(
          confirmIcon,
          size: 40,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget reservationInfoWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Restaurant Details :',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name :\n${restaurantData['name']}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Container(
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: GlobalState.secondColor, width: 1),
                  ),
                  child: Image.asset(restaurantData['icon'],
                      fit: BoxFit.fitWidth)),
            ]),
        const SizedBox(
          height: 10,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  'Address : \n${restaurantData['address']}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlobalState.logoColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        side: const BorderSide(color: GlobalState.logoColor)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Show On Map  ",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Icon(Icons.my_location, size: 18, color: Colors.white),
                    ],
                  ),
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return PlaceLocation.showLocation(
                    //       false,
                    //       LatLng(double.parse(restaurantData['lat']),
                    //           double.parse(restaurantData['long'])));
                    // }));
                  }),
            ]),
        const Divider(
          thickness: 2,
        ),
        const Text(
          'Reservation Details :',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        (canceled)
            ? const Text(
                'Status : Canceled',
                style: TextStyle(
                  color: GlobalState.logoColor,
                  fontSize: 18,
                ),
              )
            : const SizedBox(),
        if (!inProgress)
          Text(
            'Date : \n${DateFormat('EEEE d MMMM y').format(date)}\n${DateFormat.jm().format(date)}',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Number of people : \n$peopleNumber',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        (details == '' || details == null)
            ? const SizedBox()
            : Text(
                'Additional Details : \n$details',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
        (details == '' || details == null)
            ? const SizedBox()
            : const SizedBox(
                height: 10,
              ),
        Text(
          'Name : \n${GlobalState.thisUser.firstName + ' ' + GlobalState.thisUser.lastName}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Phone : \n${GlobalState.thisUser.phone}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        if (ReservationResult.isFromLog)
          const SizedBox(
            height: 10,
          ),
        if (ReservationResult.isFromLog)
          Text(
            'Created at : \n'
            '${DateFormat('EEEE d MMMM y').format(DateTime.parse(_reservationInfo['created_at']))}\n${DateFormat('jm').format(DateTime.parse(_reservationInfo['created_at']))}',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
      ],
    );
  }

  Widget refusedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: GlobalState.logoColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
            side: const BorderSide(color: GlobalState.logoColor)),
      ),
      child: const Text(
        'Try another restaurant',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false);
      },
    );
  }

  Widget actionButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalState.logoColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
                side: const BorderSide(color: GlobalState.logoColor)),
          ),
          child: const Text(
            'Edit Reservation',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RestaurantReservation(
                    restaurantData, true,
                    reservationInfo: _reservationInfo,
                    reservationID: reservationID)));
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalState.logoColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
                side: const BorderSide(color: GlobalState.logoColor)),
          ),
          child: const Text(
            'Cancel Reservation',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          onPressed: () {
            GlobalState.alert(context, onConfirm: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false);
            }, onCancel: () {
              setState(() {
                Navigator.pop(context);
              });
            },
                confirmText: 'Yes, delete my reservation',
                cancelText: 'No, go back',
                title: 'Warning',
                message: 'Are you sure you want to cancel this reservation? '
                    'this step cannot be undone.');
          },
        )
      ],
    );
  }
}
