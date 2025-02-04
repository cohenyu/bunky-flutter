import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_chart.dart';

// yuval
class BalanceCard extends StatefulWidget {
  final String title;
  final Map<String, double> map;
  final bool isPercentage;
  final double width;


  BalanceCard({this.title, this.map, this.isPercentage, this.width});

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
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
//            color: Colors.lime[300],
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
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: widget.map.isEmpty ? noExpenses() : balance(),
        ),
      ),
    );
  }

  Widget noExpenses(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.insert_chart,
            color: Colors.white.withOpacity(0.8),
            size: 200.0,
          ),
          Text(
            'Add expense to\nsee the balance',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 25.0,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }

  Widget balance(){
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: Text(
                this.widget.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ),
        Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: MyChart(data: this.widget.map, isPercentage: widget.isPercentage,),
            )
        ),
      ],
    );
  }
}
