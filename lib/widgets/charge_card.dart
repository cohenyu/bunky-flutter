import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';


class ChargeCard extends StatelessWidget {
  final String name;
  final String value;

  ChargeCard(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: BouncingWidget(
        duration: Duration(milliseconds: 100),
        scaleFactor: 1.5,
        onPressed: () {
          print("onPressed");
        },
        child: Container(
          height: 60,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 2.0,),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

