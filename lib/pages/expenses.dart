import 'dart:convert';
import 'package:bunky/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bunky/models/expanse.dart';
import 'package:bunky/widgets/drop_down_category.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:bunky/widgets/balance_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bunky/widgets/bottom_navy_bar.dart';
import 'package:bunky/widgets/expense_item.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

enum Chart{
  month,
  date
}

class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  bool refreshCharts = true;
  bool refreshList = true;
  bool totalLoading = true;
  bool categoryLoading = true;
  Map data = {};
  FloatingActionButton fab;
  FloatingActionButton fabAdd;
  List<ExpenseItem> expensesList = [];
  Future<List<ExpenseItem>> futureExpenseList;
  String url = 'https://bunkyapp.herokuapp.com';
  int expenseId = 0;
  DateTime dateTimeExpense = DateTime.now();
  DateTime dateTimeChart = DateTime.now().subtract(Duration(days: 30));
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map categories = {
    'Supermarket' : 1,
    'Water Bill' : 2,
    'Electric Bill': 3,
    'Rates': 4,
    'Building Committee' : 5,
    'Internet' : 6,
    'Other': 7
  };
  ScrollController scrollController;

  static Map<String, double> totalMap = {
//    "Or" : 120,
//    "Yuval" : 67,
//    "Miriel": 200,
//    "Amy": 93,
//    'matan': 20,
  };



  static Map<String, double> categoricalMap = {
//    'Supermarket' : 1,
//    'Water Bill' : 2,
//    'Electric Bill': 3,
//    'Rates': 4,
//    'Building Committee' : 5,
//    'Internet' : 6,
//    'Other': 7
  };

  bool removeLast = false;
  DateTime selectedDate;
  static Map<String, double> dateMap = {};
  bool reversing = false;

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

  FloatingActionButton getFab(){
    if(reversing){
      return fab;
    }
    return fabAdd;
  }
  @override
  void initState() {
    scrollController = ScrollController();
    fab = FloatingActionButton(
      backgroundColor: Colors.teal[300].withOpacity(0.9),
      child: Icon(Icons.arrow_upward),
      onPressed: (){
      scrollController.animateTo(0, duration: Duration(milliseconds: 700), curve: Curves.ease);
    },);
    fabAdd = FloatingActionButton(
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
    );

    scrollController.addListener((){
      if (scrollController.position.pixels > 600 && scrollController.position.userScrollDirection == ScrollDirection.forward){
        // you are at bottom position
        setState(() {
          reversing = true;
        });
      } else {
        setState(() {
          reversing = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data  = ModalRoute.of(context).settings.arguments;
    if(refreshCharts){
      refreshCharts = false;
      sumExpensePerUser(Chart.month, DateTime.now().subtract(Duration(days: 30)));
      sumExpensePerCategory();
    }
    if(refreshList){
      refreshList = false;
      getExpenses();
    }
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomNavyBar(),
      floatingActionButton: getFab(),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: scrollController,
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
                          Navigator.pushNamed(context, '/balancing', arguments: {'user': data['user']});
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
                    (!totalLoading && !categoryLoading) ? CarouselSlider(
                      options: CarouselOptions(
                          height: 410.0,
                          autoPlay: true,
                          enlargeCenterPage: false,
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
                    ) : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 410,
                          width: 310,
                          child: Center(
                            child: SpinKitCircle(
                              color: Colors.grey[600],
                              size: 50.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 370, left: 35),
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
                expensesList.isEmpty ? Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top:20),
                  child: Text(
                    'No Expenses Yet',
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
                        'Last Expenses',
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
                physics: PageScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: expensesList.length,
                itemBuilder: (context, int index){
                  return Dismissible(
                    key: Key('${expensesList[index].expanse.id}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction){
                      deleteExpanse(index);
                      expensesList.removeAt(index);
                      setState(() {
                      });
                    },
                    background: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(
                        color: Colors.redAccent,
                        child: Center(
                          child: ListTile(
                            trailing: Icon(Icons.delete, color: Colors.white, size: 30.0,),
                          ),
                        ),
                      ),
                    ),
                    child: expensesList[index],
                  );
                },
              ),
            ),
                expensesList.isNotEmpty ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                  ),
                ): SizedBox.shrink(),
                SizedBox(height: 30,),
              ],
            ),
          ),
//          Padding(
//            padding: const EdgeInsets.all(10.0),
//            child: Align(
//              alignment: Alignment.bottomRight,
//              child: FloatingActionButton(
//                heroTag: "tag2",
//                child: Icon(
//                    Icons.add
//                ),
//                onPressed: (){
//                  setState(() {
//                    showAddDialog();
//                  });
//                },
//                backgroundColor: Colors.pink.withOpacity(0.9),
//              ),
//            ),
//          ),
        ],
      )
    );
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
    selectedDate = date;
    setState(() {
      if(removeLast){
        balances.removeLast();
      } else {
        removeLast = true;
      }
      balances.add(BalanceCard(title: title , map: dateMap, isPercentage: isPercentage,));
    });
//    sumExpensePerUser(Chart.date, date);
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
                                print('the value in int ${int.parse(value)}');
                                if (value.isEmpty) {
                                  return 'Value is required';
                                }
                                if(int.parse(value) < 1){
                                  return 'Invalid Amount';
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
                                  addExpanse(category, categoryId,  titleController.text, double.parse(valueController.text), dateTimeExpense);
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

  Future<void> sumExpensePerCategory() async{
    setState(() {
      categoryLoading = true;
    });
    print('get sum per category');
    User user = data['user'];
    String date = DateTime.now().subtract(Duration(days: 30)).toString().split(' ')[0];
    print(date);

//    try {
    final response = await http.post(
        '$url/computeSumExpensesPerCat', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode({
      'user': user,
      'date': date,
    }
    )).timeout(const Duration(seconds: 7));
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    print(jsonData);
    if(response.statusCode == 200){
      Map<String, double> tmpMap = {};
      bool haveExpenses = false;
      for(var key in jsonData.keys){
        if(jsonData[key] != 0){
          haveExpenses = true;
        }
        tmpMap.putIfAbsent(key, ()=> jsonData[key]);
      }

      if(haveExpenses){
        setState(() {
          categoricalMap.clear();
          categoricalMap.addAll(tmpMap);
        });
      }

    } else {
      showSnackBar('Error');
    }
    setState(() {
      categoryLoading = false;
    });
//    } catch (_) {
//      showSnackBar('No Internet Connection');
//    }
  }

  Future<void> sumExpensePerUser(Chart kind, DateTime dateTime) async{
    setState(() {
      totalLoading = true;
    });
    print('get sum per user');
    User user = data['user'];
    String date = dateTime.toString().split(' ')[0];
//    String date = DateTime.now().subtract(Duration(days: 30)).toString().split(' ')[0];

    final response = await http.post(
        '$url/computeSumExpenses', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode({
      'user': user,
      'date': date,
    }
    )).timeout(const Duration(seconds: 7));
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    print(jsonData);
    if(response.statusCode == 200){
      Map<String, double> tmpMap = {};
      bool haveExpenses = false;
      for(var key in jsonData.keys){
        if(jsonData[key] != 0){
          haveExpenses = true;
        }
        tmpMap.putIfAbsent(key, ()=> jsonData[key]);
      }

      if(haveExpenses){
        if(kind == Chart.month){
          setState(() {
            totalMap.clear();
            totalMap.addAll(tmpMap);
          });
        } else {
          setState(() {
            dateMap.clear();
            dateMap.addAll(tmpMap);
          });
        }
      }

    } else {
      showSnackBar('Error');
    }
    setState(() {
      totalLoading = false;
    });

//    try {

//    } catch (_) {
//      showSnackBar('No Internet Connection');
//    }
  }

// This function delete expense from the expenses list and sends http delete to the server
  Future<void> deleteExpanse(int index) async{
    Expense expense = expensesList[index].expanse;

    try{
      final response = await http.put(
          '$url/removeExpense', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, body: jsonEncode(expense.id,)).timeout(const Duration(seconds: 7));
      print('delete in DB');
      print(response.body);
      if(response.statusCode == 200){
        if(response.body.isNotEmpty){
          showSnackBar('Expense deleted');
          return;
        } else {
          showSnackBar('Error');
        }
      } else {
        showSnackBar('Error');
      }
    }catch(_){
      print('point 2');
      showSnackBar('No Internet Connection');
    }

//  In case of error we don't want to delete the expense
    setState(() {
      expensesList.add(ExpenseItem(expense));
    });
  }

// This function returns n expenses of the apartment
  Future<void> getExpenses() async{
    User user = data['user'];
    int limit = 20;
    List<ExpenseItem> expenseItems = [];

//    try{
      final response = await http.get(
          '$url/getAptExpensesWithLimit?userId=${user.userId}&name=${user.name}&mail=${user.mail}&limit=$limit', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },).timeout(const Duration(seconds: 7));

      List jsonData = jsonDecode(response.body);
//      var reversedList = List.from(jsonData.reversed);
      if(response.statusCode == 200){
        print('200 OK');
        if(response.body.isNotEmpty){
          for(var jsonItem in jsonData){
            print(jsonItem);
            ExpenseItem item = ExpenseItem(Expense.fromJson(jsonItem));
            setState(() {
              expensesList.add(item);
            });
            expenseItems.add(item);
          }

        }
      } else {
        print('no expenses yet');
      }
//    }catch(_){
//      print('point 1');
//      showSnackBar('No Internet Connection');
//    }
  }


//  this function adds expense to the expenses list
  Future<void> addExpanse(String category,int categoryId, String title, double value, DateTime date) async{
    try{
      //    http post
      User user = data['user'];
      final response = await http.post(
          '$url/addExpense', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, body: jsonEncode({
        'user': user,
        'categoryId': categoryId,
        'title': title,
        'date': date.toString().split(' ')[0],
        'amount': value,
      }
      )).timeout(const Duration(seconds: 10));

      if(response.statusCode == 200){
        print("200 OK Expenses");
        print(jsonDecode(response.body));
        Expense expense = Expense.fromJson(jsonDecode(response.body));
        ExpenseItem newItem = ExpenseItem(expense);
        setState(() {
          expensesList.insert(0, newItem);
//      update the charts just if the expense was maximum 30 days ago
//          if (categoricalMap.containsKey(category)){
//            categoricalMap[category] = categoricalMap[category] + value;
//          }
//          String name = user.name;
//          if(totalMap.containsKey(name)){
//            totalMap[name]  += value;
//          }
//          if(dateMap.containsKey(user.name)){
//            dateMap[name] += value;
//          }
          refreshCharts = true;
        });
      } else {
        showSnackBar('Error');
        print('somthing went worng');
      }
    } catch (_){
      print('point 3');
      showSnackBar('No Internet Connection');
    }
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
