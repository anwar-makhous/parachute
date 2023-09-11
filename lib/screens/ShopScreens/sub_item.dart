import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_group_button/flutter_group_button.dart';
import '../../global_state.dart';

class SubItem extends StatefulWidget {
  final String type;
  final String title;
  final List<String> subItems;
  final List<double> prices;
  final bool required;

  const SubItem(
      {required this.type,
      required this.title,
      required this.subItems,
      required this.prices,
      required this.required,
      Key? key})
      : super(key: key);

  @override
  _SubItemState createState() => _SubItemState();
}

class _SubItemState extends State<SubItem> {
  String type = "SingleChoice";
  String title = "";
  List<String> subItems = [];
  List<double> prices = [];
  bool required = false;
  bool expanded = true;
  int _key = 0;
  String subtitleText = "select items";
  List<String?> selectedItems = [];

  _collapse() {
    int newKey = 0;
    do {
      _key = Random().nextInt(10000);
    } while (newKey == _key);
  }

  @override
  void initState() {
    super.initState();
    type = widget.type;
    title = widget.title;
    subItems = widget.subItems;
    prices = widget.prices;
    required = widget.required;
    subtitleText =
        (type == "SingleChoice") ? "select one item" : "select items";
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: (required)
          ? const Text(
              "required",
              style: TextStyle(color: GlobalState.logoColor),
            )
          : const Text(
              "optional",
              style: TextStyle(color: GlobalState.secondColor),
            ),
      iconColor: GlobalState.logoColor,
      initiallyExpanded: expanded,
      key: Key(_key.toString()),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        subtitleText,
        style: selectedItems.isEmpty
            ? const TextStyle(color: GlobalState.secondColor)
            : const TextStyle(color: Colors.black),
      ),
      children: <Widget>[
        (type == "SingleChoice")
            ? RadioGroup(
                defaultSelectedItem: selectedItems.isEmpty
                    ? -1
                    : subItems.indexOf(selectedItems.first!),
                onSelectionChanged: (label) {
                  setState(() {
                    selectedItems = [];
                    selectedItems.add(subItems[label!]);
                    subtitleText = selectedItems.first!;
                    expanded = false;
                    _collapse();
                  });
                },
                activeColor: GlobalState.logoColor,
                groupItemsAlignment: GroupItemsAlignment.column,
                textBeforeRadio: false,
                children: [
                  for (int i = 0; i < subItems.length; i++)
                    Text(subItems[i] + "\n" + prices[i].toString() + " SP")
                ],
              )
            : CheckboxGroup(
                activeColor: GlobalState.logoColor,
                groupItemsAlignment: GroupItemsAlignment.column,
                textBeforeCheckbox: false,
                child: {
                  for (int i = 0; i < subItems.length; i++)
                    Text(subItems[i] + "\n" + prices[i].toString() + " SP"):
                        selectedItems.contains(subItems[i]) ? true : false
                },
                onNewChecked: (labels) {
                  setState(() {
                    selectedItems = labels;
                    if (labels.isNotEmpty) {
                      for (int i = 0; i < selectedItems.length; i++) {
                        selectedItems[i] = selectedItems[i]
                            ?.replaceAll("\n", "")
                            .replaceAll(" SP", "")
                            .replaceAllMapped(RegExp(r'[0-9]'), (match) => "")
                            .replaceAll(".", "");
                      }
                    }
                    subtitleText = labels.isEmpty
                        ? "select items"
                        : selectedItems
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", "");
                  });
                },
              ),
      ],
    );
  }
}
