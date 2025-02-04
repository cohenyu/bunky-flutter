import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
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
  int tasksNumber = 0;
  double userBalance = 0;
  IconData homeIcon = Icons.bubble_chart;
  bool tasksLoading = true;
  bool balanceLoading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

//  DateTime backButtonPressesTime;
//
//  Future<bool> onWillPop() async{
//    DateTime currentTime = DateTime.now();
//    bool backButton = backButtonPressesTime == null || currentTime.difference(backButtonPressesTime) > Duration(seconds: 3);
//    if (backButton){
//      backButtonPressesTime = currentTime;
//      Fluttertoast.showToast(
//          msg: 'Double click to exit app',
//        backgroundColor: Colors.black54,
//        textColor: Colors.white
//      );
//      return false;
//    }
//    return true;
//  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    user = data['user'];
    if(firstTime){
      firstTime = false;
      getUserBalance();
      getTasksToCompleteNumber();
      getExpenses();
    }
    Color primaryColor = Colors.teal.withOpacity(0.5);
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomNavyBar(),
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: CustomShapeClipper(),
              child: Container(
                height: 330.0,
                decoration: BoxDecoration(color: primaryColor),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 40.0,),
                                Text(
                                  'Hey ${user.name},',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Let\'s see your updates for today',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 30.0, right: 5.0, left: 5.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width-60,
                                    height: 370.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.95),
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
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
//                                      Padding(
//                                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
//                                        child: Row(
//                                          mainAxisAlignment: MainAxisAlignment.start,
//                                          children: <Widget>[
//                                            Material(
//                                              color: Colors.deepOrangeAccent.withOpacity(0.2),
//                                              shape: CircleBorder(),
//                                              child: Padding(
//                                                padding: const EdgeInsets.all(8.0),
//                                                child: Icon(Icons.notifications_none, color: Colors.deepOrangeAccent, size: 30.0,),
//                                              ),
//                                            ),
//                                          ],
//                                        ),
//                                      ),
//                                      Divider(thickness: 1.0,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Material(
                                                color: Colors.deepOrangeAccent.withOpacity(0.2),
                                                shape: CircleBorder(),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(13.0),
                                                  child: Icon(Icons.calendar_today, color: Colors.deepOrangeAccent, size: 25.0,),
                                                ),
                                              ),
                                              SizedBox(width: 17.0,),
                                              Expanded(
                                                child: tasksLoading ? Text(
                                                  '---',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0),
                                                ) : new RichText(
                                                  text: new TextSpan(
                                                    // Note: Styles for TextSpans must be explicitly defined.
                                                    // Child text spans will inherit styles from parent
                                                    style: new TextStyle(
                                                      fontSize: 23.0,
                                                      color: Colors.black.withOpacity(0.7),
                                                    ),
                                                    children: tasksNumber > 0 ? <TextSpan>[
                                                      new TextSpan(text: 'You have'),
                                                      new TextSpan(text: ' $tasksNumber duties', style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo[300])),
                                                      new TextSpan(text: ' to complete'),
                                                    ]: <TextSpan>[
                                                      new TextSpan(text: 'You don\'t have any duties to complete!', style: new TextStyle(fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Material(
                                                color: Colors.deepOrangeAccent.withOpacity(0.2),
                                                shape: CircleBorder(),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Icon(Icons.show_chart, color: Colors.deepOrangeAccent, size: 30.0,),
                                                ),
                                              ),
                                              SizedBox(width: 17.0,),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                      'Your balance:',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black.withOpacity(0.7),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 23,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    balanceLoading ? Text(
                                                      '---',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black.withOpacity(0.7),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 23,
                                                      ),
                                                    ) : Text(
                                                      userBalance <= 0 ? '$userBalance${user.currency}' : '+$userBalance${user.currency}',
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          color: userBalance < 0 ? Colors.redAccent: Colors.lightGreen,
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  recentExpanses.isEmpty || _load ? SizedBox.shrink() : Padding(
//              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
                    padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          recentExpanses.isNotEmpty ? 'Recent expenses' : 'No expenses',
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
          ],
        ),
    );
  }


  Future<void> getUserBalance() async{
    User user = data['user'];

    try{
      final response = await http.get(
        '$url/getMyPersonalTotalBalance?userId=${user.userId}&name=${user.name}&mail=${user.mail}', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },).timeout(const Duration(seconds: 7));

      if(response.statusCode == 200){
        if(response.body.isNotEmpty){
          setState(() {
            userBalance = jsonDecode(response.body);
          });
        }
      } else {
        showSnackBar('Error');
      }
    }catch (_){
      showSnackBar('No Internet Connection');
    }

    setState(() {
      balanceLoading = false;
    });
  }


  Future<void> getTasksToCompleteNumber() async{
    int tmpTasksNumber = 0;
    User user = data['user'];

    try{
      final response = await http.get(
        '$url/getMyDuties?userId=${user.userId}&name=${user.name}&mail=${user.mail}', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },).timeout(const Duration(seconds: 7));

      if(response.statusCode == 200){
        if(response.body.isNotEmpty){
          List jsonData = jsonDecode(response.body);
          for(var jsonTask in jsonData){
            if(jsonTask['shift']['executed'] == false){
              tmpTasksNumber ++;
            }
          }

        }
      } else {
        showSnackBar('Error');
      }
    }catch (_){
      showSnackBar('No Internet Connection');
    }

    setState(() {
      tasksNumber = tmpTasksNumber;
      tasksLoading = false;
    });
  }

  Future<void> getExpenses() async{

    User user = data['user'];
    int limit = 7;

    try{
      final response = await http.get(
        '$url/getAptExpensesWithLimit?userId=${user.userId}&name=${user.name}&mail=${user.mail}&limit=$limit', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },).timeout(const Duration(seconds: 7));

      if(response.statusCode == 200){
        if(response.body.isNotEmpty){
          List jsonData = jsonDecode(response.body);
          for(var jsonItem in jsonData){
            ExpenseCard card = ExpenseCard(expense: Expense.fromJson(jsonItem), currency: '${user.currency}',);
            if(mounted){
              setState(() {
                _load = false;
                recentExpanses.add(card);
              });
            }
          }
        }
      } else {
        showSnackBar('Error');
      }
    }catch (_){
      showSnackBar('No Internet Connection');
    }

    setState(() {
      _load = false;
    });
  }

  void showSnackBar (String title){
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.pink[50],
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.pink
            ),
          ),
        ],
      ),
    ));
  }
}



