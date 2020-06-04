import 'dart:convert';
import 'package:bunky/models/user.dart';
import 'package:bunky/pages/logo.dart';
import 'package:flutter/material.dart';
import 'package:bunky/widgets/custom_shape_clipper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';


class ConnectApartment extends StatefulWidget {
  @override
  _ConnectApartmentState createState() => _ConnectApartmentState();
}

class _ConnectApartmentState extends State<ConnectApartment> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int code;
  Map data = {};
  bool _loading = false;
  bool _autoValidate = false;


  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    Logo logo = Logo(title: 'Signup');
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.teal,
      body: ModalProgressHUD(
        color: Colors.black,
        inAsyncCall: _loading,
        progressIndicator: Center(
          child: SpinKitCircle(
            color: Colors.grey[600],
            size: 50.0,
          ),
        ),
        child: Stack(
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
                            fontSize: 20.0,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                    child: Form(
                      autovalidate: _autoValidate,
                        key:  formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
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
                                  Icons.home,
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
                                  setState(() {
                                    _autoValidate = true;
                                  });
                                  return;
                                }
                                formKey.currentState.save();
                                setState(() {
                                  _loading = true;
                                });
                                submitCode();
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
      ),
    );
  }

  Future<void> submitCode() async {
    try{
      final response = await http.put(
          'https://bunkyapp.herokuapp.com/loginApt', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, body: jsonEncode({
        'user': data['user'],
        'aptCode': code,
      }
      )).timeout(const Duration(seconds: 10));

      setState(() {
        _loading = false;
      });

      if(response.statusCode == 200){

        if(response.body.isEmpty){
          print('AptCode not found');
          showSnackBar('Apartment Code Not Found');
        } else {
          Navigator.pushReplacementNamed(context, '/home', arguments: {
            'user': data['user'],
            'index': 0,
          });
        }
      } else {
        print('error');
        showSnackBar('Error');
      }

    } catch (_){
      print('No Internet Connection');
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

