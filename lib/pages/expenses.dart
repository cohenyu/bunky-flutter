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
  date,
}

enum Chart2{
  user,
  category,
}

class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  bool isLoading = true;
  bool totalLoading = true;
  bool categoryLoading = true;
  bool removeDateChart = false;
  bool reversing = false;

  DateTime selectedDate;

  DateTime fromDate;
  DateTime toDate;

  FloatingActionButton fab;
  FloatingActionButton fabAdd;
  List<ExpenseItem> expensesList = [];
  String url = 'https://bunkyapp.herokuapp.com';


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map data = {};
  Map categories = {
    'Supermarket' : 1,
    'Water Bill' : 2,
    'Electric Bill': 3,
    'Rates': 4,
    'Building Committee' : 5,
    'Internet' : 6,
    'Other': 7
  };
  static Map<String, double> totalMap;
  static Map<String, double> categoricalMap;
  static Map<String, double> dateMap;

  ScrollController scrollController;

  int _current  = 0;
  List<T> map<T>(List list, Function handler){
    List<T> result = [];
    for(var i = 0; i < list.length; i++){
      result.add(handler(i, list[i]));
    }
    return result;
  }

  List<Widget> balances = [
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
    totalMap = {};
    categoricalMap = {};
    dateMap = {};
    fromDate = DateTime.now().subtract(Duration(days: DateTime.now().day - 1));
    print(fromDate);
    toDate = DateTime.now();
    balances.add(BalanceCard(title: 'Total Expenses', map: totalMap, isPercentage: false,));
    balances.add(BalanceCard(title: 'Categorical Expenses', map: categoricalMap, isPercentage: false,));
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
      if (scrollController.position.pixels > 200 && scrollController.position.userScrollDirection == ScrollDirection.forward){
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

    WidgetsBinding.instance.addPostFrameCallback((_){
      print(MediaQuery.of(context).size.toString());
      data = ModalRoute.of(context).settings.arguments;
      setState(() {
        getExpensesByDate(fromDate, toDate);
        updateChartExpenses();
      });

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomNavyBar(),
      floatingActionButton: getFab(),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 25.0, bottom: 20.0, right: 25.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Expenses',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.3),
                                fontWeight: FontWeight.bold,
                                fontSize: 35.0
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '${parseDate(fromDate)} - ${parseDate(toDate)}',
//                                '12/2/20 - 15/2/20',
                                style: TextStyle(fontSize: 16.7, color: Colors.black.withOpacity(0.5)),
                              ),
                              SizedBox(width: 5.0,),
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    showDateDialog();
                                  });
                                },
                                child: Icon(Icons.edit, color: Colors.pink, size: 19.0,),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Container(
                          child: RaisedButton.icon(
                            color: Colors.teal[400],
                            icon: Icon(Icons.insert_chart),
                            onPressed: (){
                              Navigator.pushNamed(context, '/balancing', arguments: {'user': data['user']});
                            },
                            label: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                "Balance",
                                style: TextStyle(fontSize: 17.0),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                isLoading ?  Container(
                  height: 320,
                  width: 310,
                  child: Center(
                    child: SpinKitCircle(
                      color: Colors.grey[600],
                      size: 50.0,
                    ),
                  ),
                ) : Column(
                  children:  expensesList.isNotEmpty ? showExpenses() : hideExpenses(),
                )
              ],
            ),
          ),
        ],
      )
    );
  }

  List<Widget> hideExpenses(){
    return [
      Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 100,),
            Container(
              height: 90,
              width: 150,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Icon(
                      Icons.star,
                      size: 100.0,
                      color: Colors.teal.withOpacity(0.2),
                    ),
                    left: 45,
                  ),
                  Positioned(
                    child: Icon(
                      Icons.star_border,
                      size: 40.0,
                      color: Colors.teal.withOpacity(0.2),
                    ),
                    top: 40,
                    left: 25,
                  )
                ],
              ),
            ),
            Text(
                'no expenses',
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.black.withOpacity(0.4)
              ),
            )
          ],
        ),
      )
       ,
    ];
  }

  String parseDate(DateTime dateTime){
    String date = dateTime.toString().split(' ')[0];
    var dateData = date.split('-');
    String year = dateData[0];
    year = year.substring(2, year.length);
    String month = dateData[1];
    String day = dateData[2];
    return '$day/$month/$year';
  }

  List<Widget> showExpenses(){
    return [
      (!totalLoading && !categoryLoading) ? CarouselSlider(
        options: CarouselOptions(
            aspectRatio: 2.0,
            height: 320.0,
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
            height: 320,
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
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map(balances, (index, url){
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? Colors.grey[800] : Colors.grey
                ),
              );
            })
        ),
      ),
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
                setState(() {
                  expensesList.removeAt(index);
                  showSnackBar('Expense deleted');
                });
              },
              background: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150.0),
        child: Divider(
          thickness: 4.0,
        ),
      ),
      SizedBox(height: 30,),
    ];
  }

  void showDateDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          DateTime tmpFrom = fromDate;
          DateTime tmpTo = toDate;
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
                          Text(
                            'Show Expenses',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(width: 20.0,),
                              Text(
                                'From:',
                                style: TextStyle(fontSize: 18.0),
                              ),
//                              SizedBox(width: 4.0,),
                              Text(
                                  '${tmpFrom.day}/${tmpFrom.month}/${tmpFrom.year.toString().substring(2)}',
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              RaisedButton(
                                color: Colors.deepOrange[200],
                                shape: CircleBorder(),
                                child: Icon(Icons.today),
                                onPressed: (){
                                  showDatePicker(
                                    context: context,
                                    initialDate: tmpFrom == null ? DateTime.now() : tmpFrom,
                                    firstDate: DateTime(2020),
                                    lastDate: tmpTo,
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
                                        tmpFrom = dateValue;
                                      }
                                    });
                                  });
                                },
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(width: 20.0,),
                              Text(
                                'To:',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              SizedBox(width: 15.0,),
                              Text(
                                '${tmpTo.day}/${tmpTo.month}/${tmpTo.year.toString().substring(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                              ),
                              RaisedButton(
                                color: Colors.deepOrange[200],
                                shape: CircleBorder(),
                                child: Icon(Icons.today),
                                onPressed: (){
                                  showDatePicker(
                                    context: context,
                                    initialDate: tmpTo == null ? DateTime.now() : tmpTo,
                                    firstDate: tmpFrom,
                                    lastDate: DateTime.now(),
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
                                        tmpTo = dateValue;
                                      }
                                    });
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.pink[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0
                                  ),
                                ),
                                onPressed: (){
                                  setState(() {
                                    fromDate = tmpFrom;
                                    toDate = tmpTo;
                                  });
                                  getExpensesByDate(fromDate, toDate);
                                  updateChartExpenses();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
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
      if(removeDateChart){
        balances.removeAt(0);
      } else {
        removeDateChart = true;
      }
      balances.insert(0, BalanceCard(title: title , map: dateMap, isPercentage: isPercentage,));
    });
    sumExpensePerUser(Chart.date, date);
  }

  void showAddDialog(){
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController titleController = new TextEditingController();
    TextEditingController valueController = new TextEditingController();
    int categoryId;
    String category;
    bool _autoValidate = false;

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
                      autovalidate: _autoValidate,
                      key:  formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Add Expense',
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
                                  hintText: 'Title',
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
                                double amount;
                                try{
                                  amount = double.parse(value);
                                  print(amount);
                                  if(amount < 1){
                                    return 'Invalid Amount';
                                  }
                                } catch(_){
                                  return 'Invalid Amount';
                                }
                                if (value.isEmpty) {
                                  return 'Value is required';
                                }
                                return null;
                              },
//                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              keyboardType: TextInputType.number,
                              controller: valueController,
                              decoration: InputDecoration(
                                hintText: 'Value',
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
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.pink[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
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
                                  if(!formKey.currentState.validate()){
                                    setState(() {
                                      _autoValidate = true;
                                    });
                                    return;
                                  }
                                  if(expensesList.isEmpty){
                                    isLoading = true;
                                  }
                                  formKey.currentState.save();
                                  print("im here");
                                  DateTime dateTimeExpense = DateTime.now();
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

  Future<void> updateChartExpenses() async{
    sumExpensePerCategory();
    sumExpensePerUser(Chart.month, DateTime.now().subtract(Duration(days: 30)));
  }

  Future<void> sumExpensePerCategory() async{

    User user = data['user'];
    String date = DateTime.now().subtract(Duration(days: 30)).toString().split(' ')[0];

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


//  **********************************************************************************************
  // This function returns expenses of the apartment from date x to date y
  Future<void> getExpensesByDate(DateTime dateTimeFrom, DateTime dateTimeTo) async{
    setState(() {
      isLoading = true;
    });
    User user = data['user'];
    String fromDate = dateTimeFrom.toString().split(' ')[0];
    String toDate = dateTimeTo.toString().split(' ')[0];

    List<ExpenseItem> expenseItems = [];

//    try{
    final response = await http.get(
      '$url/getAptExpensesBetweenDates?userId=${user.userId}&name=${user.name}&mail=${user.mail}&fromDate=$fromDate&toDate=$toDate',
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },).timeout(const Duration(seconds: 7));

    List jsonData = jsonDecode(response.body);
    jsonData = List.from(jsonData.reversed);
    if(response.statusCode == 200){
      print('200 OK');
      if(response.body.isNotEmpty){
        expensesList.clear();
        for(var jsonItem in jsonData){
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

    setState(() {
      isLoading = false;
    });
//    }catch(_){
//      print('point 1');
//      showSnackBar('No Internet Connection');
//    }
  }

  Future<void>  getChart (Chart2 kind, DateTime dateTimeFrom, DateTime dateTimeTo) async{
    setState(() {
      if(kind == Chart2.user){
        categoryLoading = true;
      } else{
        totalLoading = true;
      }
    });

    String specificUrl = kind == Chart2.user ? 'computeSumExpenses': 'computeSumExpensesPerCat';
    User user = data['user'];
    String dateFrom = dateTimeFrom.toString().split(' ')[0];
    String dateTo = dateTimeTo.toString().split(' ')[0];

    final response = await http.post(
        '$url/$specificUrl', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode({
      'user': user,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
    }
    )).timeout(const Duration(seconds: 7));
    Map<String, dynamic> jsonData = jsonDecode(response.body);

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
        if(kind == Chart2.user){
          setState(() {
            totalMap.clear();
            totalMap.addAll(tmpMap);
          });
        } else {
          setState(() {
            categoricalMap.clear();
            categoricalMap.addAll(tmpMap);
          });
        }
      }

    } else {
      showSnackBar('Error');
    }
    setState(() {
      if(kind == Chart2.user){
        categoryLoading = false;
      } else{
        totalLoading = false;
      }
    });

//    try {

//    } catch (_) {
//      showSnackBar('No Internet Connection');
//    }
  }

//  **********************************************************************************************


// This function delete expense from the expenses list and sends http delete to the server
  Future<void> deleteExpanse(int index) async{
    Expense expense = expensesList[index].expanse;

    try{
      final response = await http.put(
          '$url/removeExpense', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, body: jsonEncode(expense.id,)).timeout(const Duration(seconds: 7));

      if(response.statusCode == 200){
        if(response.body.isNotEmpty){
//          todo refresh charts if the date is between the range
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

      setState(() {
        isLoading = false;
      });
//    }catch(_){
//      print('point 1');
//      showSnackBar('No Internet Connection');
//    }
  }


//  this function adds expense to the expenses list
  Future<void> addExpanse(String category,int categoryId, String title, double value, DateTime date) async{
    setState(() {
      categoryLoading = true;
      totalLoading = true;
    });
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
        Expense expense = Expense.fromJson(jsonDecode(response.body));
        ExpenseItem newItem = ExpenseItem(expense);
        setState(() {
          expensesList.insert(0, newItem);
          updateChartExpenses();
        });
      } else {
        showSnackBar('Error');
        print('somthing went worng');
      }
    } catch (_){
      print('point 3');
      showSnackBar('No Internet Connection');
    }
    setState(() {
      isLoading = false;
    });
  }

  void showSnackBar (String title){
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
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
