import 'dart:convert';

import 'package:bunky/pages/logo.dart';
import 'package:flutter/material.dart';
import 'package:bunky/widgets/custom_shape_clipper.dart';
import 'package:http/http.dart' as http;


class ConnectApartment extends StatefulWidget {
  @override
  _ConnectApartmentState createState() => _ConnectApartmentState();
}

class _ConnectApartmentState extends State<ConnectApartment> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int code;
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    Logo logo = Logo();
    return Scaffold(
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Text(
                      'Please enter your apartment code',
                      style: TextStyle(
                          fontSize: 20.0
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                  child: Form(
                      key:  formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            onSaved: (value){
                              this.code = int.parse(value);
                            },
                            validator: (value){
                              if (value.isEmpty) {
                                return 'Code is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Apartment code',
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: Colors.pink,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          SizedBox(
                            height: 25.0,
                          ),
                          FloatingActionButton(
                            onPressed: (){
                              if(!formKey.currentState.validate()){
                                return;
                              }
                              formKey.currentState.save();
                              postCode();
                            },
                            backgroundColor: Colors.yellow[300],
                            elevation: 3,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> postCode() async {
    final response = await http.put(
        'https://bunkyapp.herokuapp.com/loginApt', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode({
      'user': data['user'],
      'aptCode': code,
    }
    ));

    if(response.statusCode == 200){
      print("200 OK");
      print(response.body);
    } else {
      print('somthing went worng');
    }
  }
}

