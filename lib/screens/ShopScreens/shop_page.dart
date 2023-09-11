import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parachute_delivery/data/shops.dart';
import '../../global_state.dart';
import 'product_details.dart';
import 'restaurant_reservation.dart';

class Shop extends StatefulWidget {
  final int shopIndex;
  final int categoryIndex;
  const Shop(this.categoryIndex, this.shopIndex, {Key? key}) : super(key: key);

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List _menuCategories = [];
  bool inProgress = false;
  bool hasDelivery = false;
  bool hasReservation = false;
  bool isOpen = false;
  Map _shopData = {};
  String closingDays = '';
  bool freeDelivery = true;
  int shopIndex = 0;
  int categoryIndex = 0;

  getData() {
    _shopData = Shops.shops[categoryIndex]['shops'][shopIndex];
    _menuCategories = _shopData['menu_categories'];
    hasDelivery = (_shopData['delivery'] == 1) ? true : false;
    hasReservation = (_shopData['category_id'] == 1)
        ? (_shopData['reservation'] == 1)
            ? true
            : false
        : false;
    isOpen = checkForOpening(_shopData['open_days'], _shopData['open_hours']);
  }

  @override
  void initState() {
    shopIndex = widget.shopIndex;
    categoryIndex = widget.categoryIndex;
    inProgress = false;
    getData();
    super.initState();
    freeDelivery = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: (inProgress)
          ? GlobalState.progressIndicator(context, transparent: false)
          : Scaffold(
              appBar: AppBar(
                title: Text("${_shopData['name']}"),
                centerTitle: true,
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                    ),
                    onPressed: () {},
                  ),
                ],
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
                children: [mainBody(), addToBasket()],
              )),
    );
  }

  Widget mainBody() {
    return DefaultTabController(
      length: _menuCategories.length,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              pinned: true,
              backgroundColor: Colors.white,
              expandedHeight: 1100,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    shopImage(),
                    shopInfo(),
                  ],
                ),
              ),
              bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: GlobalState.logoColor,
                  indicatorWeight: 3.5,
                  labelColor: Colors.black,
                  tabs: [
                    for (int i = 0; i < _menuCategories.length; i++)
                      Tab(text: _menuCategories[i]["name"]),
                  ]),
            ),
          ];
        },
        body: TabBarView(
          children: [
            for (int i = 0; i < _menuCategories.length; i++)
              dataVerticalListView(i),
          ],
        ),
      ),
    );
  }

  Widget shopInfo() {
    return Flexible(
      child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 3,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: GlobalState.secondColor, width: 0.5),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60),
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(14.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (hasDelivery)
                        GlobalState.rateWithColoredStars(3,
                            text: const Text('Delivery',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                )),
                            isRow: false),
                      if (hasReservation)
                        GlobalState.rateWithColoredStars(5,
                            text: const Text('Reservation',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                )),
                            isRow: false),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _shopData['name'],
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        GlobalState.rateWithBlackStars(_shopData['rank']),
                      ],
                    ),
                    Container(
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: GlobalState.secondColor, width: 1),
                        ),
                        child: Image.asset("${_shopData['icon']}",
                            fit: BoxFit.fitWidth))
                  ],
                ),
                Text(
                  _shopData['details'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: GlobalState.secondColor,
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                if (hasDelivery)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Delivery Time : ${_shopData['service_time']} Minutes",
                        style: const TextStyle(
                          fontSize: 16,
                          color: GlobalState.secondColor,
                        ),
                      ),
                      GlobalState.parachuteIcon(size: 40, onPress: () {}),
                    ],
                  ),
                if (hasDelivery && freeDelivery)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Free Delivery",
                        style: TextStyle(
                          fontSize: 16,
                          color: GlobalState.secondColor,
                        ),
                      ),
                      Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    ],
                  ),
                if (hasDelivery)
                  const Divider(
                    thickness: 2,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const Text(
                      "Address :",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: GlobalState.secondColor,
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GlobalState.logoColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Show On Map  ",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Icon(Icons.my_location,
                                size: 18, color: Colors.white),
                          ],
                        ),
                        onPressed: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return PlaceLocation.showLocation(
                          //       false,
                          //       LatLng(double.parse(_shopData['lat']),
                          //           double.parse(_shopData['long'])));
                          // }));
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${_shopData['address']}",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: GlobalState.secondColor,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      (isOpen) ? "Open Now" : "Closed Now",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: (isOpen) ? Colors.green : GlobalState.logoColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        (closingDays == 'Opens Everyday')
                            ? closingDays
                            : (closingDays == '')
                                ? 'Opens Everyday'
                                : "Off Days : $closingDays",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 16,
                          color: GlobalState.secondColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Opening Hours : ${_shopData['open_hours']}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: GlobalState.secondColor,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                if (hasReservation)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GlobalState.logoColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Book A Table",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Icon(Icons.arrow_forward,
                                size: 18, color: Colors.white),
                          ],
                        ),
                        onPressed: () {
                          // if (GlobalState.loggedIn == true) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return RestaurantReservation(_shopData, false);
                          }));
                          // } else {
                          //   GlobalState.alert(context, onConfirm: () {
                          //     // setState(() {
                          //     //   Navigator.pop(context);
                          //     //   Navigator.push(context,
                          //     //       MaterialPageRoute(builder: (context) {
                          //     //     return LoginPage();
                          //     //   }));
                          //     // });
                          //   }, onCancel: () {
                          //     Navigator.pop(context);
                          //   },
                          //       title: 'You\'re not logged in',
                          //       message: 'In order to book a table '
                          //           'and make a reservation you have to log in or '
                          //           'create an account',
                          //       confirmText: "OK",
                          //       cancelText: "Cancel");
                          // }
                        },
                      ),
                    ],
                  ),
                if (hasReservation)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Online Reservation Is Available',
                          style: TextStyle(
                            fontSize: 16,
                            color: GlobalState.secondColor,
                          )),
                    ],
                  ),
                if (hasReservation)
                  const Divider(
                    thickness: 2,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GlobalState.logoColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Reviews  ",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Icon(Icons.rate_review,
                                size: 18, color: Colors.white),
                          ],
                        ),
                        onPressed: () {}),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GlobalState.rateWithColoredStars(_shopData['rate'],
                        text: const Text('General Rate',
                            style: TextStyle(
                              fontSize: 16,
                              color: GlobalState.secondColor,
                            ))),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Based on 60 reviews",
                      style: TextStyle(
                        fontSize: 16,
                        color: GlobalState.secondColor,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          )),
    );
  }

  Widget dataVerticalListView(int catIndex) {
    return ListView.builder(
        itemCount: _shopData['menu_categories'][catIndex]['items'].length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  navigateToMeal(catIndex, index, _shopData);
                },
                child: Container(
                  height: 130,
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 15, bottom: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _shopData['menu_categories'][catIndex]['items']
                                  [index]['name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              _shopData['menu_categories'][catIndex]['items']
                                  [index]["details"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14, color: GlobalState.secondColor),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              "SP ${_shopData['menu_categories'][catIndex]['items'][index]["price"]}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14.0)),
                            border: Border.all(
                                color: Colors.black.withAlpha(20), width: 1),
                          ),
                          child: Image.asset(
                              "${_shopData['menu_categories'][catIndex]['items'][index]["image"]}",
                              fit: BoxFit.fill))
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
            ],
          );
        });
  }

  Widget addToBasket() {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
            margin: const EdgeInsets.only(right: 25, left: 25, bottom: 15),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              color: GlobalState.logoColor,
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "Add items",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Total: SP 0.00",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )));
  }

  void navigateToMeal(int catIndex, int itemIndex, Map data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return InfoPage(catIndex, itemIndex, data);
    }));
  }

  bool checkForOpening(String openDaysString, String openHoursString) {
    if (openHoursString == '24/7') {
      closingDays = 'Opens Everyday';
      return true;
    }
    DateTime now = DateTime.now();
    List<String> closingDaysList = [
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
    closingDaysList.removeWhere((day) => openDays.contains(day));
    closingDays = (closingDaysList.isEmpty)
        ? 'Opens Everyday'
        : closingDaysList
            .toString()
            .replaceFirst('[', '')
            .replaceFirst(']', '');
    openHoursString = openHoursString.replaceAll(' - ', '-');
    List<String> openHours = openHoursString.split('-');
    String today = DateFormat('EEEE').format(now);
    bool workDay = (openDays.contains(today)) ? true : false;
    if (workDay) {
      DateTime start = DateTime(
          now.year,
          now.month,
          now.day,
          DateFormat.jm().parse(openHours[0]).hour,
          DateFormat.jm().parse(openHours[0]).minute);
      DateTime end = DateTime(
          now.year,
          now.month,
          (openHours[1].contains('AM')) ? now.day + 1 : now.day,
          DateFormat.jm().parse(openHours[1]).hour,
          DateFormat.jm().parse(openHours[1]).minute);
      return (now.isAfter(start) && now.isBefore(end));
    } else {
      return false;
    }
  }

  Widget shopImage() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          "${_shopData['photo']}",
          fit: BoxFit.fitWidth,
        ));
  }
}
