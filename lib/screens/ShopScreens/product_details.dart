import 'package:flutter/material.dart';
import '../../global_state.dart';
import 'sub_item.dart';

class InfoPage extends StatefulWidget {
  final int itemIndex;
  final int catIndex;
  final Map data;

  const InfoPage(this.catIndex, this.itemIndex, this.data, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InfoPage();
}

class _InfoPage extends State<InfoPage> {
  int itemIndex = 0;
  int catIndex = 0;
  Map data = {};
  int amount = 0;
  double total = 0.0;
  double price = 0.0;

  _InfoPage();

  @override
  void initState() {
    super.initState();
    itemIndex = widget.itemIndex;
    catIndex = widget.catIndex;
    data = widget.data;
    price =
        data['menu_categories'][catIndex]['items'][itemIndex]['price'] * 1.0;
    amount = 1;
    total = price;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                mealImage(),
                const SizedBox(
                  height: 15,
                ),
                mealInfo(),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                margin: const EdgeInsets.only(right: 25, left: 25, bottom: 15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: GlobalState.logoColor,
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "SP ${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Add to basket",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ]),
      ),
    );
  }

  Widget specialRequest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: const TextSpan(children: [
            WidgetSpan(
              child: Icon(
                Icons.add_comment,
              ),
            ),
            TextSpan(
                text: '  Special request?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
            TextSpan(
                text: '  (optional)',
                style: TextStyle(
                  color: GlobalState.secondColor,
                  fontSize: 16,
                )),
          ]),
        ),
        const TextField(
          maxLength: 50,
          decoration: InputDecoration(
              hintText: "Tap to enter request",
              hintStyle: TextStyle(fontSize: 14)),
        )
      ],
    );
  }

  Widget amountCalculator() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 70),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                if (amount > 0) {
                  amount--;
                  total = amount * price;
                }
              });
            },
            child: const Icon(
              Icons.remove,
              size: 30,
              color: GlobalState.logoColor,
            ),
          ),
          Text(
            "$amount",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (amount < 100) {
                  amount++;
                  total = amount * price;
                }
              });
            },
            child: const Icon(
              Icons.add,
              size: 30,
              color: GlobalState.logoColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    amount = 0;
    total = 0.0;
  }

  Widget mealInfo() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['menu_categories'][catIndex]['items'][itemIndex]['name'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              data['menu_categories'][catIndex]['items'][itemIndex]['details'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "SP ${data['menu_categories'][catIndex]['items'][itemIndex]['price']}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            SubItem(
                type: data['menu_categories'][catIndex]['items'][itemIndex]
                    ['subitems'][0]["type"],
                title: data['menu_categories'][catIndex]['items'][itemIndex]
                    ['subitems'][0]["title"],
                subItems: data['menu_categories'][catIndex]['items'][itemIndex]
                    ['subitems'][0]["subItems"],
                prices: data['menu_categories'][catIndex]['items'][itemIndex]
                    ['subitems'][0]["prices"],
                required: data['menu_categories'][catIndex]['items'][itemIndex]
                            ['subitems'][0]["required"] ==
                        1
                    ? true
                    : false),
            SubItem(
                type: data['menu_categories'][catIndex]['items'][itemIndex]
                    ['subitems'][1]["type"],
                title: data['menu_categories'][catIndex]['items'][itemIndex]
                    ['subitems'][1]["title"],
                subItems: data['menu_categories'][catIndex]['items'][itemIndex]
                    ['subitems'][1]["subItems"],
                prices: data['menu_categories'][catIndex]['items'][itemIndex]
                    ['subitems'][1]["prices"],
                required: data['menu_categories'][catIndex]['items'][itemIndex]
                            ['subitems'][1]["required"] ==
                        1
                    ? true
                    : false),
            specialRequest(),
            amountCalculator(),
          ],
        ));
  }

  Widget mealImage() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        "${data['menu_categories'][catIndex]['items'][itemIndex]['image']}",
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
