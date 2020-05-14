import 'dart:convert';

import 'package:bunky/models/refund.dart';
import 'package:bunky/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bunky/widgets/my_shape_clipper.dart';
import 'package:bunky/widgets/drop_down_names.dart';
import 'package:flutter/services.dart';
import 'package:bunky/widgets/charge_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Balancing extends StatefulWidget {
  @override
  _BalancingState createState() => _BalancingState();
}

class _BalancingState extends State<Balancing> {
//  bool _autoValidate = false;
  bool ready = false;
  bool refreshBalance = true;
  User selectedUser;
  bool isChanged = false;
  Color primaryColor = Colors.teal;
  Map data = {};
  String url = 'https://bunkyapp.herokuapp.com';
  List<ChargeCard> credit = [
    ChargeCard('yuval', '100'),
    ChargeCard('Or', '240'),
    ChargeCard('Miriel', '240'),
  ];
  List<ChargeCard> debt = [
    ChargeCard('yuval', '-96'),
    ChargeCard('Miriel', '289')
  ];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data  = ModalRoute.of(context).settings.arguments;
    if(refreshBalance){
      refreshBalance = false;
      getBalance();
    }
    bool isBalanceExist  = debt.isNotEmpty || credit.isNotEmpty;
    return Scaffold(
        resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            ClipPath(
              clipper: CustomShapeClipper(),
              child: Container(
                height: 350.0,
                decoration: BoxDecoration(color: primaryColor),
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 40.0),
                      child: FloatingActionButton(
                        onPressed: (){
                          Navigator.pop(context, isChanged);
                        },
                        backgroundColor: Colors.yellow[300],
                        elevation: 3,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, right: 25.0, left: 25.0),
                  child: Container(
                    height: 450,
                    width: double.infinity,
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
                    child: !isBalanceExist ?
                    Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.mood, size: 45, color: Colors.grey,),
                            SizedBox(height: 8.0,),
                            Text(
                                "Wer'e  all balanced out!",
                              style: TextStyle(fontSize: 20.0, color: Colors.grey),
                            )
                          ],
                        )
                    ) :
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: isLoading ? Center(
                        child: SpinKitCircle(
                          color: Colors.grey[600],
                          size: 50.0,
                        ),
                      ) :Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 120,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_downward,
                                  color: Colors.red,
                                  size: 50.0,
                                ),
                                Text(
                                  'Debt',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                Column(
                                  children: debt
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 120,
                            child: Column(
                              children: <Widget>[
                                AnimatedContainer(
                                  child: Icon(
                                    Icons.arrow_upward,
                                    color: Colors.green,
                                    size: 50.0,
                                  ),
                                  duration: Duration(seconds: 10),
                                  curve: Curves.bounceIn,
                                ),
                                Text(
                                  'Credit',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                Column(
                                  children: credit,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                isBalanceExist && !isLoading ?  Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: RaisedButton(
                    color: Colors.teal[400],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Refund",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    onPressed: (){showRefundDialog();},
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30),
                    ),
                  ),
                ) : SizedBox.shrink(),
              ],
            ),
          ],
        ),
      )

    );
  }


  Future<void> postRefund(Refund refund)async{
    setState(() {
      isLoading = true;
    });
    print(refund.toJson());
    final response = await http.post(
        '$url/addRefund', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode(refund.toJson(),)).timeout(const Duration(seconds: 5));

    print(jsonDecode(response.body));
    if(response.statusCode == 200){
      print('200 OK - refund');
    }

    setState(() {
      refreshBalance = true;
    });
  }

//  Future<void> getBalance()async{
//    await Future.delayed(const Duration(seconds: 4), (){});
//    setState(() {
//      credit.removeLast();
//      isLoading = false;
//    });
//  }


  Future<void> getBalance() async{
    User user = data['user'];

//    try {
    final response = await http.post(
        '$url/computeUserBalance', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode(user.toJson())).timeout(const Duration(seconds: 5));

    print(jsonDecode(response.body));
    if(response.statusCode == 200){
      print('200 OK');
      if(response.body.isNotEmpty){
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        Map<String, dynamic> userDebt = jsonData['userDebt'];
        Map<String, dynamic> userCredit = jsonData['userCredit'];

        List<ChargeCard> tmpCredit = [];
        List<ChargeCard> tmpDebt = [];

        for(var key in userDebt.keys){
          tmpDebt.add(ChargeCard(key, userDebt[key].toString()));
        }

        for(var key in userCredit.keys){
          tmpCredit.add(ChargeCard(key, userCredit[key].toString()));
        }
        setState(() {
          credit = tmpCredit;
          debt = tmpDebt;
          isLoading = false;
        });

      }
    }
//    Map<String, dynamic> jsonData = jsonDecode(response.body);
//    print(jsonData);
//    if(response.statusCode == 200){
//      Map<String, double> tmpMap = {};
//      for(var key in jsonData.keys){
//        print(key);
//        print(jsonData[key].runtimeType);
//
//        tmpMap.putIfAbsent(key, ()=> jsonData[key]);
//      }
//
//      setState(() {
//        categoricalMap.clear();
//        categoricalMap.addAll(tmpMap);
//      });
//
//    } else {
//      showSnackBar('Error');
//    }
//    } catch (_) {
//      showSnackBar('No Internet Connection');
//    }
    setState(() {
      isLoading = false;
    });
  }

  void showRefundDialog(){
    bool _autoValidate = false;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController valueController = new TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (context, setState){
              return Center(
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  backgroundColor: Colors.teal[100],
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 280,
                      width: double.infinity,
                      child: Form(
                        key:  formKey,
                        autovalidate: _autoValidate,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Refund',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 26.0
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: DropDownNames(callback: (val) => setState(()=> selectedUser = val), user: data['user'],)
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: TextFormField(
                                  validator: (value){
                                    double amount;
                                    try{
                                      amount = double.parse(value);
                                      if(amount < 0){
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
                              SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                    color: Colors.pink[800],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(10),
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
                                      borderRadius: new BorderRadius.circular(10),
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
                                      formKey.currentState.save();
                                      String refundDate = DateTime.now().toString().split(' ')[0];
                                      Refund refund = Refund(user: data['user'], receiver: selectedUser, amount: double.parse(valueController.text),  date: refundDate);
                                      postRefund(refund);
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
                  ),
                ),
              );
            },
          );
        }
    );
  }
}
