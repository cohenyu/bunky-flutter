import 'package:bunky/models/categories.dart';
import 'package:flutter/material.dart';
import 'package:bunky/models/expanse.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expanse;
  final String currency;

  ExpenseItem({this.expanse, this.currency});

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
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    width: 120.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0,),
                      child: Text(
                        this.expanse.user.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.teal,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 25.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                  this.expanse.value % 1 == 0 ? '${this.expanse.value.toInt()}': '${this.expanse.value}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              SizedBox(width: 2,),
                              Text(
                                 currency,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ],
                          ),
                          Text(
                            dateString,
                            style: TextStyle(
                              letterSpacing: 0.7,
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          this.expanse.category,
                          style: TextStyle(
                              color: Colors.pink[300].withOpacity(0.7),
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    this.expanse.title != null && this.expanse.title.isNotEmpty ? Text(
                      this.expanse.title,
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
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
