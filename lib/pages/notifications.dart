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

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Map data = {};
  Color primaryColor = Colors.teal;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    getNotifications();
  }


  Future<void> getNotifications() async{
    notificationsList = ['notification1', 'notification2', 'notification3', 'notification4', 'notification4', 'notification4', 'notification4', 'notification4', 'notification4', 'notification4'];
  }

//  @override
//  Widget build(BuildContext context) {
//    data  = ModalRoute.of(context).settings.arguments;
//
//    return Scaffold(
//      body: Container(
//        child: FutureBuilder(
//          future: getNotifications(),
//          builder: (_, snapshot){
//            if(snapshot.connectionState == ConnectionState.waiting){
//              return Center(
//                child: Text('waiting'),
//              );
//            } else{
//              return Center(
//                child: ListView.builder(
//                    itemCount: snapshot.data.length,
//                    itemBuilder: (_, index){
//                      return ListTile(
//                        title: Text(snapshot.data[index]),
//                      );
//                    }),
//              );
//            }
//          },
//        ),
//      ),
//    );
//  }

  List<String> notificationsList;

  @override
  Widget build(BuildContext context) {
    data  = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Positioned(
              bottom: -10,
              right: -150,
              child: Icon(Icons.notifications_none,color: Colors.teal[50], size: 370,),
            ),
//            Padding(
//              padding: const EdgeInsets.only(top: 120.0),
//              child: FutureBuilder(
//                future: notificationsList,
//                builder: (_, snapshot){
//                  if(snapshot.connectionState == ConnectionState.waiting){
//                    return Center(
//                      child: Text('waiting'),
//                    );
//                  } else{
//                    return Padding(
//                      padding: const EdgeInsets.only(top: 30.0, bottom: 25.0),
//                      child: ListView.builder(
//                          itemCount: snapshot.data.length,
//                          itemBuilder: (_, index){
//                            bool flag = true;
//                            return Card(
//                              elevation: 10.0,
//                              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
//                              color: Colors.teal[100].withOpacity(0.8),
//                              child: ListTile(
//                                enabled: flag,
//                                onTap: (){
//                                  flag = false;
//                                },
//                                leading: Icon(Icons.monetization_on, size: 40.0,),
//                                title: Text('${snapshot.data[index]}', style: TextStyle(fontSize: 18.0),),
//                                trailing: Icon(Icons.more_horiz),
//                              ),
//                            );
//                          }),
//                    );
//                  }
//                },
//              ),
//            ),
//            ClipPath(
//              clipper: CustomShapeClipper(),
//              child: Container(
//                height: 350.0,
//                decoration: BoxDecoration(color: primaryColor),
//              ),
//            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0, top: 40.0),
                                child: FloatingActionButton(
                                  onPressed: (){
                                    Navigator.pop(context, isChanged);
                                  },
                                  backgroundColor: Colors.pink[400],
                                  elevation: 3,
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0, left: 30.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Notifications',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35.0
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.5, right: 25.0, bottom: 0),
                  child: Container(
                    height: 450,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: notificationsList.length,
                        itemBuilder: (context, int index){
                          return Card(
                              elevation: 10.0,
                              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                              color: Colors.teal[100].withOpacity(0.8),
                              child: ListTile(
                                onTap: (){
                                  setState(() {
                                    notificationsList.removeAt(index);
                                  });
                                },
//                                leading: Icon(Icons.monetization_on, size: 40.0,),
                                title: Text('${notificationsList[index]}', style: TextStyle(fontSize: 18.0),),
                                trailing: Icon(Icons.more_horiz),
                              ),
                            );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        )
    );
  }


//  Future<void> postRefund(Refund refund)async{
//    setState(() {
//      isLoading = true;
//    });
//    print(refund.toJson());
//    final response = await http.post(
//        '$url/addRefund', headers: <String, String>{
//      'Content-Type': 'application/json; charset=UTF-8',
//    }, body: jsonEncode(refund.toJson(),)).timeout(const Duration(seconds: 5));
//
//    print(jsonDecode(response.body));
//    if(response.statusCode == 200){
//      print('200 OK - refund');
//    }
//
//    setState(() {
//      refreshBalance = true;
//    });
//  }


//  Future<void> getBalance() async{
//    User user = data['user'];
//
////    try {
//    final response = await http.post(
//        '$url/computeUserBalance', headers: <String, String>{
//      'Content-Type': 'application/json; charset=UTF-8',
//    }, body: jsonEncode(user.toJson())).timeout(const Duration(seconds: 5));
//
//    print(jsonDecode(response.body));
//    if(response.statusCode == 200){
//      print('200 OK');
//      if(response.body.isNotEmpty){
//        Map<String, dynamic> jsonData = jsonDecode(response.body);
//        Map<String, dynamic> userDebt = jsonData['userDebt'];
//        Map<String, dynamic> userCredit = jsonData['userCredit'];
//
//        List<ChargeCard> tmpCredit = [];
//        List<ChargeCard> tmpDebt = [];
//
//        for(var key in userDebt.keys){
//          tmpDebt.add(ChargeCard(key, userDebt[key].toString()));
//        }
//
//        for(var key in userCredit.keys){
//          tmpCredit.add(ChargeCard(key, userCredit[key].toString()));
//        }
//        setState(() {
//          credit = tmpCredit;
//          debt = tmpDebt;
//          isLoading = false;
//        });
//
//      }
//    }
////    Map<String, dynamic> jsonData = jsonDecode(response.body);
////    print(jsonData);
////    if(response.statusCode == 200){
////      Map<String, double> tmpMap = {};
////      for(var key in jsonData.keys){
////        print(key);
////        print(jsonData[key].runtimeType);
////
////        tmpMap.putIfAbsent(key, ()=> jsonData[key]);
////      }
////
////      setState(() {
////        categoricalMap.clear();
////        categoricalMap.addAll(tmpMap);
////      });
////
////    } else {
////      showSnackBar('Error');
////    }
////    } catch (_) {
////      showSnackBar('No Internet Connection');
////    }
//    setState(() {
//      isLoading = false;
//    });
//  }
}
