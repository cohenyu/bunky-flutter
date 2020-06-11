import 'dart:convert';
import 'package:bunky/widgets/custom_shape_clipper.dart';
import 'package:bunky/models/user.dart';
import 'package:flutter/material.dart';
import 'package:bunky/pages/logo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NewApartment extends StatefulWidget {
  @override
  _NewApartmentState createState() => _NewApartmentState();
}


class _NewApartmentState extends State<NewApartment> {
  bool haveApt = false;
  Map data = {};

  @override
  Widget build(BuildContext context) {
    print(haveApt);
//    todo
    data = ModalRoute.of(context).settings.arguments;
    Logo logo = Logo(title: "Sign up");
    return SafeArea(
      child: Scaffold(
//        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.teal,
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: CustomShapeClipper(),
              child: Container(
                height: 1000,
                decoration: BoxDecoration(color: Colors.white),
              ),
            ),
            Container(
              child: ListView(
                children: <Widget>[
                  logo.getLogo(),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          height: 60,
                          child: RaisedButton.icon(
                            color: Colors.teal,
                            onPressed: (){
                              Navigator.pushNamed(context,'/aptSettings', arguments: {
                                'user': data['user'],
                              }).then((value){
                                haveApt = true;
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Let\'s create a new apartment!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 60,
                          child: RaisedButton.icon(
                            color: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30),
                            ),
                            onPressed: (){
                              Navigator.pushNamed(context, '/connectApartment', arguments: {
                                'user': data['user'],
                              });
                            },
                            icon: Icon(
                              Icons.home,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Already have a code',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  wordSpacing: 2
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}


