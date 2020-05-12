import 'dart:convert';

import 'package:bunky/models/task.dart';
import 'package:bunky/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bunky/widgets/my_shape_clipper.dart';
import 'package:bunky/models/expanse.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bunky/widgets/bottom_navy_bar.dart';
import 'package:bunky/widgets/expense_card.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  User user;
  List<Widget> recentExpanses = [];
  List<Widget> notifications = [];
  bool _load = true;
  String url = 'https://bunkyapp.herokuapp.com';
  bool firstTime = true;

  List<Task> tasks = [
    Task(performer: 'Or', name: 'throw the garbage out', frequency: 'everyday'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    user = data['user'];
    if(firstTime){
      firstTime = false;
      getExpenses();
    }
    print('build');
//    Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
    Color primaryColor = Colors.teal;
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(),
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
                border: Border.all(color: primaryColor)
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 30.0, right: 15.0, left: 15.0),
                child: SizedBox(
                  height: 20,
                )
              ),
            ),
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: CustomShapeClipper(),
                  child: Container(
                    height: 350.0,
                    decoration: BoxDecoration(color: primaryColor),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Hey ${user.name},',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            'Let\'s see your updates for today',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 120.0, right: 25.0, left: 25.0),
                  child: Container(
                    width: double.infinity,
                    height: 370.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0.0, 3.0),
                          blurRadius: 15.0,
                        )
                      ]
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Material(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Colors.deepOrange[400].withOpacity(0.5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.notifications_none,
                                        color: Colors.deepOrange[400],
                                        size: 25.0,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Your task is to throw the garbage out.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey[400].withOpacity(0.15),
                                child: IconButton(
                                  icon: Icon(Icons.check),
                                  color: Colors.amberAccent,
                                  onPressed: (){
                                    showAddDialog();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40,),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(height: 40,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Your total balance:',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '-2000',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.lightBlue[700],
                                        fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            recentExpanses.isEmpty || _load ? SizedBox.shrink() : Padding(
//              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
              padding: EdgeInsets.only(left: 25.0, top: 30.0, bottom: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    recentExpanses.isNotEmpty ? 'Recently expenses' : 'No expenses yet',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Icon(
                      Icons.arrow_right,
                      size: 30.0,
                    ),
                  )
                ],
              ),
            ),
//            _load ? Padding(
//              padding: const EdgeInsets.only(top: 30.0),
//              child: SpinKitThreeBounce(
//                color: Colors.grey[600],
//                size: 25.0,
//              ),
//            ) :
//            ,
              recentExpanses.isEmpty || _load ? SizedBox.shrink() :Padding(
              padding: EdgeInsets.only(left: 25.0, bottom: 25.0, right: 10.0),
              child: Container(
                height: 140.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentExpanses.length,
                  itemBuilder: (context, int index){
                    return recentExpanses[index];
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future<void> getExpenses() async{

    User user = data['user'];
    int limit = 7;
    List<ExpenseCard> expenseCards = [];

    final response = await http.get(
      '$url/getAptExpensesWithLimit?userId=${user.userId}&name=${user.name}&mail=${user.mail}&limit=$limit', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },).timeout(const Duration(seconds: 7));

    if(response.statusCode == 200){
      print('200 OK');
      if(response.body.isNotEmpty){
        List jsonData = jsonDecode(response.body);
        for(var jsonItem in jsonData){
          ExpenseCard card = ExpenseCard(expense: Expense.fromJson(jsonItem),);
          if(mounted){
            setState(() {
              _load = false;
              recentExpanses.add(card);
            });
          }
        }

      }
    } else {
      print('no expenses yet');
    }
    setState(() {
      _load = false;
    });
//
//    List<Widget> expenses = [
//      ExpenseCard(expense: Expense(title: 'Food', value: 20, category: 'Building Committee', date: '12.2.20', user: user)),
//      ExpenseCard(expense: Expense(title: 'Food', value: 99, category: 'Internet', date: '12.2.20', user: user)),
//      ExpenseCard(expense: Expense(title: 'Food', value: 330, category: 'Other', date: '12.2.20', user: user)),
//      ExpenseCard(expense: Expense(title: 'Food', value: 200, category: 'Other', date: '12.2.20', user: user)),
//      ExpenseCard(expense: Expense(title: 'Food', value: 67, category: 'Other', date: '12.2.20', user: user)),
//    ];

  }

  void showAddDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            backgroundColor: Colors.teal[100],
            content: Container(
              height: 170,
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Did you complete the task?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.lightGreen[400],
                          size: 25.0,
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 25.0,
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}


