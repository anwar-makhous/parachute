import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/screens/Login/social_login.dart';
import '../../global_state.dart';
import '../ShopScreens/shop_page.dart';
import 'Drawer/account_info.dart';
import 'Drawer/change_email.dart';
import 'Drawer/drawer.dart';
import '../../data/data_horizontal.dart';
import 'Drawer/reservations_list.dart';
import 'custom_paint.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static FoodCategoryHorizontal dataHorizontal = FoodCategoryHorizontal();
  List foodData = dataHorizontal.food;
  bool isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> adsImages = [];
  final List _categoriesList = GlobalState.categoriesList;
  int categoryPressed = 0;
  bool inProgress = false;
  // List? _searchedList;
  String _search = '';
  bool searchInProgress = false;
  bool carouselCreated = false;
  TextEditingController textEditingController = TextEditingController();

  Future<void> refreshPage() async {
    // await Future.delayed(Duration(seconds: 1));
    // setState(() {
    //   getData();
    //   categoriesHorizontalList(context);
    // });
    // return null;
  }

  @override
  void initState() {
    super.initState();
    categoryPressed = 0;
    searchInProgress = false;
    carouselCreated = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!carouselCreated) {
      createAdsCarousel(context);
      carouselCreated = true;
    }
    final double sliverAppBarHeight = MediaQuery.of(context).size.height * 0.25;
    final double paintHeight = MediaQuery.of(context).size.height * 0.35;
    final double toolbarHeight = MediaQuery.of(context).size.height * 0.12;
    final double logoHeight = MediaQuery.of(context).size.height * 0.1;
    final double searchBottom = MediaQuery.of(context).size.height * 0.01;
    final double searchHeight = MediaQuery.of(context).size.height * 0.08;
    final double searchWidth = MediaQuery.of(context).size.width * 0.66;
    return SafeArea(
        top: true,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          drawer: Drawer(
              child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: GlobalState.logoColor,
                ),
                child: Image.asset("assets/logo/Parachute"
                    " Logo on Red.png"),
              ),
              CustomListTile(
                  Icons.person,
                  "Profile",
                  () => {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccountInfo()),
                            (route) => false)
                      }),
              const Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(
                  Icons.email,
                  "Change Email",
                  () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChangeEmail()))
                      }),
              const Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(Icons.vpn_key, "Change Password", () => {}),
              const Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(Icons.notifications, "Notifications", () => {}),
              const Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(
                  Icons.history,
                  "Your Reservations",
                  () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReservationsList()))
                      }),
              const Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(Icons.history, "Your Orders", () => {}),
              const Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(Icons.settings, "Settings", () => {}),
              const Divider(
                thickness: 1,
                color: GlobalState.secondColor,
              ),
              CustomListTile(Icons.phone, "Contact Us", () => {}),
              (GlobalState.loggedIn)
                  ? const Divider(thickness: 1, color: GlobalState.secondColor)
                  : Container(),
              (GlobalState.loggedIn)
                  ? CustomListTile(Icons.logout, "Log Out", () {
                      GlobalState.alert(
                        context,
                        onConfirm: () {
                          // GlobalState.logOut();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          // this.setState(() {});
                        },
                        onCancel: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        message: 'You\'re about to log out'
                            ' of your account',
                        title: 'Warning',
                        confirmText: "Log Out",
                        cancelText: "Cancel",
                      );
                    })
                  : Container(),
            ],
          )),
          body: RefreshIndicator(
            child: Stack(children: [
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    backgroundColor: Colors.white,
                    expandedHeight: sliverAppBarHeight,
                    titleSpacing: 0,
                    toolbarHeight: toolbarHeight,
                    centerTitle: true,
                    title: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: GlobalState.logoColor,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Image.asset(
                          "assets/logo/Parachute-Logo-on-Red.png",
                          height: logoHeight,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    leading: Container(
                      width: MediaQuery.of(context).size.width,
                      color: GlobalState.logoColor,
                      child: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.ellipsisV,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                      ),
                    ),
                    actions: [
                      Container(
                        color: GlobalState.logoColor,
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      )
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          Positioned(
                            width: MediaQuery.of(context).size.width,
                            height: paintHeight,
                            child: CustomPaint(
                              painter: RPSCustomPainter(),
                            ),
                          ),
                          Positioned(
                            bottom: searchBottom,
                            left: MediaQuery.of(context).size.width * 0.14,
                            right: MediaQuery.of(context).size.width * 0.14,
                            child: Container(
                              width: searchWidth,
                              height: searchHeight,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(40.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: GlobalState.secondColor
                                        .withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: textEditingController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "What are you looking For ?",
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: GlobalState.secondColor,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10)),
                                onChanged: (value) {
                                  setState(() {
                                    _search = value;
                                    if (_search == "") {
                                      searchInProgress = false;
                                    } else {
                                      searchInProgress = true;
                                    }

                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (!searchInProgress)
                    SliverList(
                        delegate: SliverChildListDelegate([
                      (GlobalState.loggedIn == false)
                          ? logInCard()
                          : Container(
                              padding: const EdgeInsets.all(5),
                              child: const Text(
                                'Welcome '
                                // '${GlobalState.thisUser.firstName}'
                                ', how can we help you?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      offersHorizontalList(foodData, context),
                      const SizedBox(
                        height: 10,
                      ),
                      advertisementSlider(),
                      const SizedBox(
                        height: 10,
                      ),
                    ])),
                  if (!searchInProgress)
                    SliverAppBar(
                        pinned: true,
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                        bottom: PreferredSize(
                          preferredSize: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.width * 0.15),
                          child: (inProgress)
                              ? const Center(child: CircularProgressIndicator())
                              : categoriesHorizontalList(context),
                        )),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    mainList(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                  ])),
                ],
              ),
              Positioned(
                bottom: 0,
                height: MediaQuery.of(context).size.height * 0.1,
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height * 0.1),
                  painter: BNBCustomPainter(),
                ),
              ),
              Positioned(
                bottom: 0,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AccountInfo()),
                              (route) => false);
                        },
                        splashColor: Colors.white,
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.language,
                            color: Colors.white,
                          ),
                          onPressed: () {}),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onPressed: () {}),
                      IconButton(
                          icon: const Icon(
                            Icons.history,
                            color: Colors.white,
                          ),
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ReservationsList()))
                              }),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.86,
                left: MediaQuery.of(context).size.width * 0.4,
                right: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.08,
                child: FloatingActionButton(
                    backgroundColor: GlobalState.logoColor,
                    tooltip: 'Change Your Location',
                    child: const Icon(Icons.my_location_sharp,
                        color: Colors.white),
                    onPressed: () async {
                      // String currentLocation = await GlobalState.getLocation();
                      // GlobalState.alert(
                      //   context,
                      //   onConfirm: () {
                      //     Navigator.of(context, rootNavigator: true).pop();
                      //     // Navigator.of(context, rootNavigator: true).push(
                      //     //     MaterialPageRoute(
                      //     //         builder: (context) => PlaceLocation(true)));
                      //   },
                      //   onCancel: () {
                      //     Navigator.of(context, rootNavigator: true).pop();
                      //   },
                      //   title: "Current Location",
                      //   message: 'Your Current Location is:\n' +
                      //       currentLocation +
                      //       '\n'
                      //           "Continue to change your Location?",
                      // );
                    }),
              ),
            ]),
            onRefresh: refreshPage,
          ),
        ));
  }

  createAdsCarousel(BuildContext context) {
    for (int i = 1; i <= 2; i++) {
      adsImages.add(Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(14.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 10.0),
              ]),
          child: Image.asset(
            "assets/images/Restaurants/ad$i.jpg",
            fit: BoxFit.fill,
          )));
    }
  }

  Widget advertisementSlider() {
    return CarouselSlider(
      items: adsImages,
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1,
      ),
    );
  }

  Widget categoriesIcon(int category, Color color) {
    if (category == 0) {
      return Icon(Icons.local_dining, color: color);
    } else if (category == 1) {
      return Icon(FontAwesomeIcons.store, color: color);
    } else if (category == 2) {
      return Icon(FontAwesomeIcons.syringe, color: color);
    } else {
      return Icon(FontAwesomeIcons.hotel, color: color);
    }
  }

  Widget logInCard() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const SocialLogin();
        }));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(14.0)),
          border: Border.all(color: GlobalState.secondColor, width: 1),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: GlobalState.secondColor, width: 1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14.0),
                  topRight: Radius.circular(14.0),
                ),
              ),
              child: const Row(children: <Widget>[
                Icon(
                  Icons.person_pin,
                  size: 50,
                  color: GlobalState.logoColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Login or create an account to \n receive rewards and offers.",
                  style: TextStyle(fontSize: 15),
                )
              ]),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                alignment: Alignment.center,
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 15, color: GlobalState.logoColor),
                ))
          ],
        ),
      ),
    );
  }

  Widget shopsVerticalList(int category) {
    return ListView.builder(
        itemCount: _categoriesList[category]['shops'].length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              navigateToShop(category, index);
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: GlobalState.secondColor,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(14.0),
                  ),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _categoriesList[category]['shops'][index]['name'],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GlobalState.rateWithBlackStars(
                                  _categoriesList[category]['shops'][index]
                                      ['rank']),
                            ),
                            Text(
                              _categoriesList[category]['shops'][index]
                                  ['details'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16, color: GlobalState.secondColor),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GlobalState.rateWithColoredStars(
                                  _categoriesList[category]['shops'][index]
                                      ['rate']),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      "Delivery time: ${_categoriesList[category]['shops'][index]['service_time']} Minutes",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: GlobalState.secondColor),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: GlobalState.secondColor, width: 1),
                          ),
                          child: Image.asset(
                              "${_categoriesList[category]['shops'][index]['icon']}",
                              fit: BoxFit.fitWidth))
                    ],
                  ),
                )),
          );
        });
  }

  Widget categoriesHorizontalList(BuildContext context) {
    double categoryRibLength = MediaQuery.of(context).size.width * 0.225;
    return Container(
      alignment: Alignment.center,
      height: categoryRibLength,
      margin: const EdgeInsets.only(top: 5, bottom: 15),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _categoriesList.length,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  categoryPressed = index;
                });
              },
              child: Container(
                  width: categoryRibLength,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(14.0)),
                      border: Border.all(
                          color: (index == categoryPressed)
                              ? GlobalState.logoColor
                              : GlobalState.secondColor),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: (index == categoryPressed)
                                ? GlobalState.logoColor.withAlpha(30)
                                : GlobalState.secondColor.withAlpha(30),
                            blurRadius: 10.0),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          child: categoriesIcon(
                              index,
                              (index == categoryPressed)
                                  ? GlobalState.logoColor
                                  : GlobalState.secondColor)),
                      Text(
                        _categoriesList[index]['name'].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: (index == categoryPressed)
                                ? GlobalState.logoColor
                                : GlobalState.secondColor),
                      ),
                    ],
                  )),
            );
          }),
    );
  }

  // Widget searchedListWidget() {
  //   return FutureBuilder(
  //       future: searchResults(_search),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(
  //             child: Padding(
  //               padding: EdgeInsets.all(8.0),
  //               child: CircularProgressIndicator(),
  //             ),
  //           );
  //         }
  //         if (snapshot.hasData) {
  //           return ListView.builder(
  //               itemCount: snapshot.data.length,
  //               shrinkWrap: true,
  //               physics: NeverScrollableScrollPhysics(),
  //               itemBuilder: (context, index) {
  //                 return InkWell(
  //                   onTap: () {
  //                     navigateToShop(snapshot.data[index]['id']);
  //                   },
  //                   child: Container(
  //                       margin:
  //                           EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                       child: Padding(
  //                         padding: EdgeInsets.symmetric(
  //                             horizontal: 20, vertical: 10),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: <Widget>[
  //                             Flexible(
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: <Widget>[
  //                                   Text(
  //                                     snapshot.data[index]['name'],
  //                                     style: TextStyle(
  //                                         fontSize: 20,
  //                                         fontWeight: FontWeight.bold),
  //                                   ),
  //                                   SizedBox(
  //                                     height: 5,
  //                                   ),
  //                                   Align(
  //                                     alignment: Alignment.centerLeft,
  //                                     child: GlobalState.rateWithBlackStars(
  //                                         snapshot.data[index]['rank']),
  //                                   ),
  //                                   Text(
  //                                     snapshot.data[index]['details'],
  //                                     style: TextStyle(
  //                                         fontSize: 16,
  //                                         color: GlobalState.secondColor),
  //                                   ),
  //                                   SizedBox(
  //                                     height: 5,
  //                                   ),
  //                                   Align(
  //                                     alignment: Alignment.centerLeft,
  //                                     child: GlobalState.rateWithColoredStars(
  //                                         snapshot.data[index]['rate']),
  //                                   ),
  //                                   SizedBox(
  //                                     height: 5,
  //                                   ),
  //                                   Align(
  //                                     alignment: Alignment.centerLeft,
  //                                     child: RichText(
  //                                       text: TextSpan(
  //                                         text:
  //                                             "Delivery time: ${snapshot.data[index]['service_time']} Minutes",
  //                                         style: TextStyle(
  //                                             fontSize: 16,
  //                                             color: GlobalState.secondColor),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   SizedBox(
  //                                     height: 4,
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             Container(
  //                                 width: 70,
  //                                 decoration: BoxDecoration(
  //                                   shape: BoxShape.circle,
  //                                   border: Border.all(
  //                                       color: GlobalState.secondColor,
  //                                       width: 1),
  //                                 ),
  //                                 child: Image.network(
  //                                     "${GlobalState.hostURL + snapshot.data[index]['icon']}",
  //                                     fit: BoxFit.fitWidth))
  //                           ],
  //                         ),
  //                       )),
  //                 );
  //               });
  //         }
  //         return SizedBox();
  //       });
  // }

  Widget mainList() {
    return searchInProgress == false
        ? SingleChildScrollView(
            child: Column(children: [
              (inProgress)
                  ? const SizedBox()
                  : const SizedBox(
                      height: 10,
                    ),
              (inProgress)
                  ? const SizedBox()
                  : shopsVerticalList(categoryPressed),
            ]),
          )
        : Container();
    //Empty Container for testing
    // searchedListWidget();
  }

  void navigateToShop(int categoryIndex, int shopIndex) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Shop(categoryIndex, shopIndex);
    }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget offersHorizontalList(List data, context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.3,
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      child: ListView.builder(
          itemCount: data.length,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                    color: Colors.white,
                    border:
                        Border.all(color: GlobalState.secondColor, width: 1),
                    boxShadow: const [
                      BoxShadow(
                          color: GlobalState.secondColor, blurRadius: 5.0),
                    ]),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.25,
                        child: Image.asset(
                          "assets/offers/${data[index]["image"]}",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          data[index]["name"].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ));
          }),
    );
  }
}
