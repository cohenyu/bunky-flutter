import 'dart:convert';

import 'package:bunky/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bunky/models/expanse.dart';
import 'package:bunky/widgets/drop_down_category.dart';
import 'package:flutter/services.dart';
import 'package:bunky/widgets/balance_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bunky/widgets/bottom_navy_bar.dart';
import 'package:bunky/widgets/expense_item.dart';
import 'package:http/http.dart' as http;



class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  Map data = {};
  List<ExpenseItem> expansesList = [];
  int expenseId = 0;
  DateTime dateTimeExpense = DateTime.now();
  DateTime dateTimeChart = DateTime.now().subtract(Duration(days: 30));

  Map categories = {
    'Supermarket' : 1,
    'Water Bill' : 2,
    'Electric Bill': 3,
    'Rates': 4,
    'Building Committee' : 5,
    'Internet' : 6,
    'Other': 7
  };

  static Map<String, double> totalMap = {
    "Or" : 120,
    "Yuval" : 67,
    "Miriel": 200,
    "Amy": 93
  };

  static Map<String, double> categoricalMap = {
    'Supermarket' : 1,
    'Water Bill' : 2,
    'Electric Bill': 3,
    'Rates': 4,
    'Building Committee' : 5,
    'Internet' : 6,
    'Other': 7
  };

  bool removeLast = false;
  DateTime selectedDate;
  static Map<String, double> dateMap = {
    "Or" : 120,
    "Yuval" : 67,
    "Miriel": 200,
    "Amy": 93
  };

  int _current  = 0;
  List<T> map<T>(List list, Function handler){
    List<T> result = [];
    for(var i = 0; i < list.length; i++){
      result.add(handler(i, list[i]));
    }
    return result;
  }
  List<Widget> balances = [
    BalanceCard(title: 'Monthly Total Balance', map: totalMap, isPercentage: false,),
    BalanceCard(title: 'Monthly Categorical Balance', map: categoricalMap, isPercentage: false,),
//    BalanceCard(title: 'Total Balance', map: totalMap, isPercentage: true,),
//    BalanceCard(title: 'Categorical Balance', map: categoricalMap, isPercentage: true,),
  ];

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  _getRequests() async{

  }

  @override
  Widget build(BuildContext context) {
    data  = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 25,),
                Padding(
                  padding: EdgeInsets.only(top: 25.0, left: 25.0, bottom: 20.0, right: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Expenses',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.2),
                                fontWeight: FontWeight.bold,
                                fontSize: 32.0
                            ),
                          ),
                        ],
                      ),
                      RaisedButton.icon(
                        color: Colors.teal,
                        icon: Icon(Icons.insert_chart),
                        onPressed: (){
                          Navigator.pushNamed(context, '/balancing');
                        },
                        label: Text(
                          "Balance",
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                      )
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    CarouselSlider(
                      options: CarouselOptions(
                          height: 448.0,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          onPageChanged: (index,  reason){
                            setState(() {
                              _current = index;
                            });
                          }
                      ),
                      items: balances.map((i){
                        return Builder(
                          builder: (BuildContext context){
                            return i;
                          },
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 360, left: 30),
                      child: FloatingActionButton(
                        heroTag: "tag1",
                        onPressed: (){
                          print(balances);
                          setState(() {
                            showChartDialog();
                          });
                          print(balances);
                        },
                        backgroundColor: Colors.amber[100],
                        elevation: 3,
                        child: Icon(
                          Icons.event,
                          color: Colors.amber[300],
                          size: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: map(balances, (index, url){
                    return Container(
                      width: 10.0,
                      height: 10.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index ? Colors.grey[800] : Colors.grey
                      ),
                    );
                  })
                ),
                expansesList.isEmpty ? Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top:20),
                  child: Text(
                    'No expenses yet',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ): Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top:20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Last expenses',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Icon(
                          Icons.arrow_drop_down
                        ),
                      )
                    ],
                  ),
                ),
            SizedBox(height: 5.0),
            Padding(
              padding: EdgeInsets.only(left: 25.5, right: 25.0, bottom: 10),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: expansesList.length,
                itemBuilder: (context, int index){
                  return Dismissible(
                    key: Key('${expansesList[index].expanse.id}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction){
                      deleteExpanse(expansesList[index].expanse);
                      expansesList.removeAt(index);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Expense deleted', style: TextStyle(fontSize: 14.0),),
                      ));
                    },
                    background: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        color: Colors.redAccent,
                        child: ListTile(
                          trailing: Icon(Icons.delete, color: Colors.white, size: 30.0,),
                        ),
                      ),
                    ),
                    child: expansesList[index],
                  );
                },
              ),
            ),
                SizedBox(height: 70,)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: "tag2",
                child: Icon(
                    Icons.add
                ),
                onPressed: (){
                  setState(() {
                    showAddDialog();
                  });
                },
                backgroundColor: Colors.pink.withOpacity(0.9),
              ),
            ),
          ),
        ],
      )
    );
  }

  Future<void> deleteExpanse(Expense expense) async{
    await Future.delayed(const Duration(seconds: 4), (){});
  }



  void showChartDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (context, setState){
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    backgroundColor: Colors.teal[100],
                    content: Container(
                      height: 250,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.close),
                                color: Colors.grey,
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          Text(
                            'Choose a date to see the balance from that date to today:',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 20.0,),
                              Text('${dateTimeChart.day}.${dateTimeChart.month}.${dateTimeChart.year}'),
                              RaisedButton(
                                color: Colors.deepOrange[200],
                                shape: CircleBorder(),
                                child: Icon(Icons.today),
                                onPressed: (){
                                  showDatePicker(
                                    context: context,
                                    initialDate: dateTimeChart == null ? DateTime.now() : dateTimeChart,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2222),
                                    builder: (BuildContext context, Widget child){
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                            primaryColor: Colors.teal[100],
                                            accentColor: Colors.deepOrange[300]
                                        ),
                                        child: child,
                                      );
                                    },
                                  ).then((dateValue){
                                    setState(() {
                                      if(dateValue != null){
                                        dateTimeChart = dateValue;
                                      }
                                    });
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          RaisedButton(
                            color: Colors.pink[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0
                              ),
                            ),
                            onPressed: (){
                              String year = dateTimeChart.year.toString();
                              year = year.substring(2, year.length);
                              String date = '${dateTimeChart.day}.${dateTimeChart.month}.$year';
                              addDateChart(dateTimeChart, "balance from $date", false);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
    );
  }

  void addDateChart(DateTime date, String title, bool isPercentage){
    print(removeLast);
    selectedDate = date;
    setState(() {
      if(removeLast){
        balances.removeLast();
      } else {
        removeLast = true;
      }
      balances.add(BalanceCard(title: title , map: dateMap, isPercentage: isPercentage,));
    });
  }

  void showAddDialog(){
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController titleController = new TextEditingController();
    TextEditingController valueController = new TextEditingController();
    int categoryId;
    String category;

    showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context, setState){
            return Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  backgroundColor: Colors.teal[100],
                  content: Container(
                    height: 340,
                    width: 100,
                    child: Form(
                      key:  formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Add new Expanse',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: DropDownExpense(callback: (val1, val2){
                              setState(() {
                                category = val2;
                                categoryId = val1;
                              });
                            }, dropdownValues: categories, title: 'Select category',)
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              controller: titleController,
                              decoration: InputDecoration(
                                  hintText: 'title',
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              validator: (value){
                                if (value.isEmpty) {
                                  return 'Value is required';
                                }
                                return null;
                              },
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              controller: valueController,
                              decoration: InputDecoration(
                                hintText: 'value',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black)
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 20.0,),
//                                Text('${dateTimeExpense.day}.${dateTimeExpense.month}.${dateTimeExpense.year}'),
//                                RaisedButton(
//                                  color: Colors.deepOrange[200],
//                                  shape: CircleBorder(),
//                                  child: Icon(Icons.today),
//                                  onPressed: (){
//                                    showDatePicker(
//                                        context: context,
//                                        initialDate: dateTimeExpense == null ? DateTime.now() : dateTimeExpense,
//                                        firstDate: DateTime(2020),
//                                        lastDate: DateTime(2222),
//                                        builder: (BuildContext context, Widget child){
//                                          return Theme(
//                                            data: ThemeData.light().copyWith(
//                                              primaryColor: Colors.teal[100],
//                                              accentColor: Colors.deepOrange[300]
//                                            ),
//                                            child: child,
//                                          );
//                                        },
//                                    ).then((dateValue){
//                                      setState(() {
//                                        if(dateValue != null){
//                                          dateTimeExpense = dateValue;
//                                        }
//                                      });
//                                    });
//                                  },
//                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.pink[800],
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0
                                  ),
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                              RaisedButton(
                                color: Colors.pink[800],
                                child: Text(
                                  "Add",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0
                                  ),
                                ),
                                onPressed: (){
                                  if(!formKey.currentState.validate()){
                                    return;
                                  }
                                  formKey.currentState.save();
                                  print("im here");
                                  addExpanse(category, categoryId,  titleController.text, valueController.text, dateTimeExpense);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }

//  this function adds expense to the expenses list
  Future<void> addExpanse(String category,int categoryId, String title, String value, DateTime date) async{
    print(categoryId);
    print(category);
//    parse the date
    String year = date.year.toString();
    year = year.substring(2, year.length);
    String dateString = '${date.day}.${date.month}.$year';
//    http post
    User user = data['user'];
    final response = await http.post(
        'https://bunkyapp.herokuapp.com/addExpense', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode({
      'user': user,
      'categoryId': categoryId,
      'title': title,
      'date': date.toString().split(' ')[0],
      'amount': value
    }
    ));

    if(response.statusCode == 200){
      print("200 OK Expenses");
      print(jsonDecode(response.body));
      int expenseId = jsonDecode(response.body)['expenseId'];
      setState(() {
        Expense expense = Expense(user: user, title: title, value: value, category: category, date: dateString, id: expenseId);
        ExpenseItem newItem = ExpenseItem(expense);
        expansesList.add(newItem);
        int tmpVal = int.parse(value);
        print('the value is $value');
//      update the charts just if the expense was maximum 30 days ago
        if (categoricalMap.containsKey(category)){
          categoricalMap[category] = categoricalMap[category] + tmpVal;
        }
        String name = user.name;
        if(totalMap.containsKey(name)){
          totalMap[name]  += tmpVal;
        }
        if(dateMap.containsKey(user.name)){
          dateMap[name] += tmpVal;
        }
      });
    } else {
      print('somthing went worng');
    }
  }

}
