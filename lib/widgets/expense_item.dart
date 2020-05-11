import 'package:bunky/models/categories.dart';
import 'package:flutter/material.dart';
import 'package:bunky/models/expanse.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expanse;

  ExpenseItem(this.expanse);

  @override
  Widget build(BuildContext context) {
    var date = this.expanse.date.split('-');
    String year = date[0];
    year = year.substring(2, year.length);
    String month = date[1];
    String day = date[2];
    String dateString = '$day.$month.$year';

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Material(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Colors.teal.withOpacity(0.2),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        this.expanse.user.name,
//                    this.expanse.name,
                        style: TextStyle(
                            color: Colors.teal,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Text(
                      '${this.expanse.value}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      )
                  ),
                ],
              ),
              SizedBox(width: 25.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
//                      todo
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          this.expanse.category,
                          style: TextStyle(
                              color: Colors.pink[200].withOpacity(0.7),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 5),
                          child: Text(
                            dateString,
                            style: TextStyle(
                              letterSpacing: 0.7,
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    this.expanse.title.isNotEmpty ? Text(
                      this.expanse.title,
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                      ),
                    ): SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Divider(),
        ),
      ],
    );
  }
}
