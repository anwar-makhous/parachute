import 'package:flutter/material.dart';
import '../../../global_state.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  const CustomListTile(this.icon, this.text, this.onTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: InkWell(
        onTap: () {
          onTap();
        },
        splashColor: GlobalState.secondColor.withOpacity(0.5),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
