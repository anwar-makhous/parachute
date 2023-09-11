import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_group_button/flutter_group_button.dart';
import '../../global_state.dart';
import '/models/user.dart';
import 'reservation_result.dart';

class RestaurantReservation extends StatefulWidget {
  final Map _restaurantData;
  final Map? reservationInfo;
  final int? reservationID;
  final bool edit;

  const RestaurantReservation(this._restaurantData, this.edit,
      {Key? key, this.reservationInfo, this.reservationID})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RestaurantReservation();
}

class _RestaurantReservation extends State<RestaurantReservation> {
  Map _restaurantData = {};
  int _reservationID = 0;
  User _user = GlobalState.thisUser;
  bool edit = false;
  TextEditingController _additionalDetailsController = TextEditingController();
  Map<dynamic, dynamic> _reservationInfo = <dynamic, dynamic>{};
  List<DateTime> nextWeekOpeningDays = [];
  int selectedDate = 0;
  int selectedTime = 0;
  int selectedPeopleNoIndex = 0;
  String _reservationDate = '';
  String _reservationTime = '';
  DateTime? _reservationFullDate;
  String _reservationDetails = '';
  int _peopleNo = 1;
  List<String> timeSlots = [];
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);
  final step = const Duration(minutes: 30);
  List<String?> _specialOccasions = [];
  String _specialOccasionsFinal = '';
  bool _inProgress = false;
  String closingDaysString = '';
  List<String> closingDaysList = [];
  bool oddTiming = false;
  DateTime now = DateTime.now();

  _RestaurantReservation();

  @override
  void initState() {
    super.initState();
    _reservationID = widget.reservationID ?? -1;
    _reservationInfo = widget.reservationInfo ?? {};
    _restaurantData = widget._restaurantData;
    edit = widget.edit;
    checkEdit();
    setOpeningTimes(
        _restaurantData['open_days'], _restaurantData['open_hours']);
    if ((now.isAfter(DateTime(
            now.year, now.month, now.day, endTime.hour, endTime.minute))) &&
        !oddTiming) {
      getNextWeekOpeningDays(now.add(const Duration(days: 1)));
    } else {
      getNextWeekOpeningDays(now);
    }
    _user = GlobalState.thisUser;
    _inProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Book A Table"),
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
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
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              reservationContext(context),
              Positioned(
                  right: 0,
                  left: 0,
                  bottom: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: (selectedDate == -1 ||
                                    selectedTime == -1 ||
                                    selectedPeopleNoIndex == -1)
                                ? null
                                : () {
                                    prepareReservationInfo();
                                    setState(() {
                                      _inProgress = true;
                                    });
                                  },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.resolveWith(
                                  (states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.0),
                                      side: const BorderSide(
                                          color: GlobalState.logoColor))),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return GlobalState.logoColor
                                        .withOpacity(0.5);
                                  }
                                  return GlobalState
                                      .logoColor; // Use the component's default.
                                },
                              ),
                            ),
                            child: const Text(
                              "Submit",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ))),
                  )),
              (_inProgress) ? parachuteLogoLoading() : Container(),
            ],
          ),
        ));
  }

  Widget parachuteLogoLoading() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      width: MediaQuery.of(context).size.width,
      color: GlobalState.secondColor.withOpacity(0.7),
      child: Center(
        child: CircularPercentIndicator(
          radius: MediaQuery.of(context).size.width * 0.66,
          animation: _inProgress,
          animationDuration: 5000,
          lineWidth: 15.0,
          percent: 1,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: GlobalState.secondColor,
          progressColor: GlobalState.logoColor,
          header: const Text(
            'Sending your reservation request...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          footer: ElevatedButton(
            onPressed: () {
              setState(() {
                _inProgress = false;
              });
            },
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: GlobalState.logoColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  side: const BorderSide(color: GlobalState.logoColor)),
            ),
          ),
          center: Padding(
            padding: const EdgeInsets.all(14),
            child: Image.asset(
                'assets/logo/Parachute Logo Icon@2x - CircularLogoColor.png'),
          ),
          onAnimationEnd: () async {
            setState(() {
              _inProgress = false;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => ReservationResult(
                          _reservationInfo,
                          (edit) ? _restaurantData : _restaurantData,
                          'Pending',
                          _reservationID)),
                  (Route<dynamic> route) => false);
            });
          },
        ),
      ),
    );
  }

  Widget reservationContext(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "${_restaurantData['photo']}",
                fit: BoxFit.fitWidth,
              )),
          const SizedBox(
            height: 20,
          ),
          restaurantCard(),
          const SizedBox(
            height: 15,
          ),
          calenderHorizontalList(context),
          (selectedDate == -1) ? Container() : timeSlotsHorizontalList(context),
          (selectedTime == -1) ? Container() : numberOfPeople(context),
          (selectedPeopleNoIndex == -1)
              ? Container()
              : detailsAboutReservation(context),
          personalInformation(),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }

  Widget calenderHorizontalList(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "What Day ?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  List.generate(nextWeekOpeningDays.length + 1, (int index) {
                int lastIndex = nextWeekOpeningDays.length;
                return GestureDetector(
                  child: Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (index == selectedDate)
                            ? GlobalState.logoColor
                            : Colors.white,
                        border: Border.all(
                            color: Colors.black.withAlpha(20), width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (index == lastIndex)
                              ? const Icon(Icons.arrow_forward,
                                  color: GlobalState.secondColor)
                              : Text(
                                  DateFormat('d MMM')
                                      .format(nextWeekOpeningDays[index]),
                                  style: const TextStyle(
                                      color: GlobalState.secondColor,
                                      fontSize: 17),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          (index == lastIndex)
                              ? const Text('More',
                                  style: TextStyle(
                                      color: GlobalState.secondColor,
                                      fontSize: 17))
                              : Text(
                                  (nextWeekOpeningDays[index].day == now.day &&
                                          nextWeekOpeningDays[index].month ==
                                              now.month &&
                                          nextWeekOpeningDays[index].year ==
                                              now.year)
                                      ? 'Today'
                                      : (nextWeekOpeningDays[index].day ==
                                                  (now.day + 1) &&
                                              nextWeekOpeningDays[index]
                                                      .month ==
                                                  (now.month) &&
                                              nextWeekOpeningDays[index].year ==
                                                  now.year)
                                          ? 'Tomorrow'
                                          : DateFormat('EEEE').format(
                                              nextWeekOpeningDays[index]),
                                  style: const TextStyle(
                                      color: GlobalState.secondColor,
                                      fontSize: 17))
                        ],
                      )),
                  onTap: (index == lastIndex)
                      ? () {
                          setState(() {
                            getNextWeekOpeningDays(nextWeekOpeningDays.last
                                .add(const Duration(days: 1)));
                          });
                        }
                      : () {
                          setState(() {
                            selectedDate = index;
                            _reservationDate = DateFormat('EEEE')
                                    .format(nextWeekOpeningDays[index]) +
                                " " +
                                DateFormat('d MMM')
                                    .format(nextWeekOpeningDays[index]);
                            selectedTime = -1;
                            _reservationTime = '';
                          });
                        },
                );
              })),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget timeSlotsHorizontalList(BuildContext context) {
    setTimeSlots();
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "What Time ?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(timeSlots.length, (int index) {
                return GestureDetector(
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (index == selectedTime)
                          ? GlobalState.logoColor
                          : Colors.white,
                      border: Border.all(
                          color: Colors.black.withAlpha(20), width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(14.0)),
                    ),
                    child: Center(
                      child: Text(
                        timeSlots[index],
                        style: const TextStyle(
                            color: GlobalState.secondColor, fontSize: 17),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedTime = index;
                      _reservationTime = timeSlots[index].toString();
                    });
                  },
                );
              })),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget numberOfPeople(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "How Many People ?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(15, (int index) {
                return GestureDetector(
                  child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (index == selectedPeopleNoIndex)
                            ? GlobalState.logoColor
                            : Colors.white,
                        border: Border.all(
                            color: Colors.black.withAlpha(20), width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                                color: GlobalState.secondColor, fontSize: 17),
                          ),
                        ],
                      )),
                  onTap: () {
                    setState(() {
                      selectedPeopleNoIndex = index;
                      _peopleNo = index + 1;
                    });
                  },
                );
              })),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget detailsAboutReservation(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Details about your reservation (Optional)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _additionalDetailsController,
          textInputAction: TextInputAction.next,
          maxLines: null,
          decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: GlobalState.secondColor,
              hintText: "Enter Your Details Here",
              filled: true),
        ),
        const SizedBox(
          height: 15,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Special occasion ? (Optional)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        CheckboxGroup(
          textBeforeCheckbox: false,
          child: {
            const Text("Birthday"):
                (_specialOccasions.contains("Birthday")) ? true : false,
            const Text("Anniversary"):
                (_specialOccasions.contains("Anniversary")) ? true : false,
            const Text("This is my first visit"):
                (_specialOccasions.contains("This is my first visit"))
                    ? true
                    : false
          },
          onNewChecked: (labels) {
            _specialOccasions = labels;
          },
          activeColor: GlobalState.logoColor,
        )
      ],
    );
  }

  void getNextWeekOpeningDays(DateTime dateTime) {
    DateTime temp;
    int end = (edit)
        ? 7 * (((selectedDate / (7 - closingDaysList.length)) + 1).floor())
        : 7;
    for (int i = 0; i <= end; i++) {
      temp = getDate(dateTime.add(Duration(days: i)));
      if (!closingDaysList.contains(DateFormat('EEEE').format(temp))) {
        nextWeekOpeningDays.add(temp);
      }
    }
  }

  void setTimeSlots() {
    if ((nextWeekOpeningDays[selectedDate].day == now.day) &&
        (nextWeekOpeningDays[selectedDate].month == now.month) &&
        (nextWeekOpeningDays[selectedDate].year == now.year) &&
        (now.hour >= startTime.hour)) {
      if (now.minute >= 30) {
        final availableStartTime = TimeOfDay(hour: (now.hour + 1), minute: 0);
        if (oddTiming) {
          timeSlots = getTimes(availableStartTime,
                  const TimeOfDay(hour: 23, minute: 30), step)
              .map((x) => x.format(context))
              .toList();
        } else {
          timeSlots = getTimes(availableStartTime, endTime, step)
              .map((x) => x.format(context))
              .toList();
        }
      } else {
        final availableStartTime = TimeOfDay(hour: (now.hour), minute: 30);
        if (oddTiming) {
          timeSlots = getTimes(availableStartTime,
                  const TimeOfDay(hour: 23, minute: 30), step)
              .map((x) => x.format(context))
              .toList();
        } else {
          timeSlots = getTimes(availableStartTime, endTime, step)
              .map((x) => x.format(context))
              .toList();
        }
      }
    } else {
      if (oddTiming) {
        timeSlots = getTimes(const TimeOfDay(hour: 0, minute: 0), endTime, step)
            .map((x) => x.format(context))
            .toList();
        timeSlots.addAll(
            getTimes(startTime, const TimeOfDay(hour: 23, minute: 30), step)
                .map((x) => x.format(context))
                .toList());
      } else {
        timeSlots = getTimes(startTime, endTime, step)
            .map((x) => x.format(context))
            .toList();
      }
    }
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  Widget restaurantCard() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _restaurantData['name'],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: GlobalState.rateWithBlackStars(
                                    _restaurantData['rank'])),
                          ],
                        ),
                        Container(
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: GlobalState.secondColor, width: 1),
                            ),
                            child: Image.asset("${_restaurantData['icon']}",
                                fit: BoxFit.fitWidth)),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      _restaurantData['details'],
                      style: const TextStyle(
                          fontSize: 16, color: GlobalState.secondColor),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Address : ${_restaurantData['address']}',
                      style: const TextStyle(
                          fontSize: 16, color: GlobalState.secondColor),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      (closingDaysString == 'Opens Everyday')
                          ? closingDaysString
                          : "Off Days : $closingDaysString",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: GlobalState.secondColor,
                      ),
                    ),
                    Text(
                      "Opening Hours : ${_restaurantData['open_hours']}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: GlobalState.secondColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GlobalState.rateWithColoredStars(
                          _restaurantData['rate'],
                          text: const Text('Reservation Rate',
                              style: TextStyle(
                                fontSize: 16,
                                color: GlobalState.secondColor,
                              )),
                          isRow: true),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget personalInformation() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Personal Information :',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${_user.firstName} ${_user.lastName}',
                      style: const TextStyle(
                          fontSize: 18, color: GlobalState.secondColor),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      _user.phone,
                      style: const TextStyle(
                          fontSize: 18, color: GlobalState.secondColor),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      _user.email,
                      style: const TextStyle(
                          fontSize: 18, color: GlobalState.secondColor),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                    border:
                        Border.all(color: Colors.black.withAlpha(20), width: 1),
                  ),
                  child: const Icon(
                    Icons.person_pin,
                    color: GlobalState.logoColor,
                    size: 75,
                  ))
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkEdit() {
    if (!edit) {
      selectedDate = -1;
      selectedTime = -1;
      selectedPeopleNoIndex = -1;
      _additionalDetailsController = TextEditingController();
      _reservationID = -1;
    } else {
      selectedDate = _reservationInfo['Edit']['Date'];
      selectedTime = _reservationInfo['Edit']['Time'];
      selectedPeopleNoIndex = _reservationInfo['Edit']['People#'];
      _additionalDetailsController = TextEditingController(
          text: _reservationInfo['Edit']['Additional Details']);
      _specialOccasions = _reservationInfo['Edit']['Special Occasions'];
      _reservationDate = _reservationInfo['Date'];
      _reservationTime = _reservationInfo['Time'];
      _peopleNo = _reservationInfo['People#'];
    }
  }

  void prepareReservationInfo() {
    _specialOccasionsFinal = _specialOccasions.toString();
    _specialOccasionsFinal = _specialOccasionsFinal.replaceAll('[', '');
    _specialOccasionsFinal = _specialOccasionsFinal.replaceAll(']', '');
    _reservationDetails = (_specialOccasions.isEmpty)
        ? _additionalDetailsController.text.toString()
        : (_additionalDetailsController.text.toString() == '')
            ? _specialOccasionsFinal
            : _additionalDetailsController.text.toString() +
                "\nSpecial Occasions: $_specialOccasionsFinal";

    _reservationFullDate = DateTime(
        nextWeekOpeningDays[selectedDate].year,
        nextWeekOpeningDays[selectedDate].month,
        nextWeekOpeningDays[selectedDate].day,
        DateFormat.jm().parse(timeSlots[selectedTime]).hour,
        DateFormat.jm().parse(timeSlots[selectedTime]).minute);
    _reservationInfo = {
      'Date': _reservationDate,
      'Time': _reservationTime,
      'Full Date': _reservationFullDate,
      'People#': _peopleNo,
      'Additional Details': _reservationDetails,
      'Edit': {
        'Date': selectedDate,
        'Time': selectedTime,
        'People#': selectedPeopleNoIndex,
        'Additional Details': _additionalDetailsController.text.toString(),
        'Special Occasions': _specialOccasions,
      },
    };
  }

  void handleDays(String openDaysString) {
    List<String> closingDays = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];
    openDaysString = openDaysString.replaceAll(' ', '');
    List<String> openDays = openDaysString.split(',');
    closingDays.removeWhere((day) => openDays.contains(day));
    setState(() {
      closingDaysList = closingDays;
    });
    closingDaysString = (closingDays.isEmpty)
        ? 'Opens Everyday'
        : closingDays.toString().replaceFirst('[', '').replaceFirst(']', '');
  }

  void handleHours(String openHoursString) {
    openHoursString = openHoursString.replaceAll(' - ', '-');
    List<String> openHours = openHoursString.split('-');
    (openHours[0].contains("AM") && openHours[1].contains("PM"))
        ? oddTiming = false
        : oddTiming = true;
    startTime = TimeOfDay(
        hour: DateFormat.jm().parse(openHours[0]).hour,
        minute: DateFormat.jm().parse(openHours[0]).minute);
    endTime = TimeOfDay(
        hour: DateFormat.jm().parse(openHours[1]).hour,
        minute: DateFormat.jm().parse(openHours[1]).minute);
  }

  void setOpeningTimes(String openDaysString, String openHoursString) {
    if (openHoursString == '24/7') {
      closingDaysString = 'Opens Everyday';
      closingDaysList = [];
      startTime = const TimeOfDay(hour: 0, minute: 0);
      endTime = const TimeOfDay(hour: 23, minute: 30);
      return;
    }
    if (openHoursString == '24/24') {
      startTime = const TimeOfDay(hour: 0, minute: 0);
      endTime = const TimeOfDay(hour: 23, minute: 30);
      handleDays(openDaysString);
      return;
    }
    if (openDaysString == 'Opens Everyday') {
      closingDaysString = 'Opens Everyday';
      closingDaysList = [];
      handleHours(openHoursString);
      return;
    }
    handleDays(openDaysString);
    handleHours(openHoursString);
  }
}
