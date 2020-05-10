import 'package:bunky/models/categories.dart';
import 'package:bunky/models/expanse.dart';
import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  Expense expense;
  final Color color = Colors.amber[300];
  ExpenseCard({this.expense});

  @override
  Widget build(BuildContext context) {
    Map categoryMap = Categories().categoryToValueMap();
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(25.0))
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.attach_money, size: 25.0, color: Colors.white,)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, top:9.0, right: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(expense.user.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),
                        Text(expense.category, style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 20),),
                      ],
                    ),
                    Text('${expense.value}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}