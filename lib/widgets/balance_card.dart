import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_chart.dart';

// lalala
class BalanceCard extends StatefulWidget {
  final String title;
  final Map<String, double> map;
  final bool isPercentage;


  BalanceCard({this.title, this.map, this.isPercentage});

  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  String myTitle;
  Map<String, double> myMap;

  @override
  void initState() {
    myTitle = widget.title;
    myMap = widget.map;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
//        height: 30.0,
        width: 350.0,
        decoration: BoxDecoration(
            color: Colors.amber[200],
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0.0, 0.3),
                  blurRadius: 15.0
              )
            ]
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                this.widget.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10.0,),
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  mainAxisSize: MainAxisSize.min,
//                  children: <Widget>[
//                    Text(
//                      this.widget.title,
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 20.0,
//                          fontWeight: FontWeight.bold
//                      ),
//                    ),
//                  ],
//                ),
//              ),
              MyChart(data: this.widget.map, isPercentage: widget.isPercentage,),
            ],
          ),
        ),
      ),
    );
  }
}
