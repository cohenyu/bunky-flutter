import 'dart:convert';
import 'package:bunky/models/user.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:bunky/pages/logo.dart';
import 'package:bunky/widgets/custom_shape_clipper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

// finished
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false;
  String mail;
  bool _autoValidate = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String url = 'https://bunkyapp.herokuapp.com';

  @override
  Widget build(BuildContext context) {
    Logo logo = Logo(title: "Sign in");
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
//        resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
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
//            crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    logo.getLogo(),
                    Container(
                      padding: EdgeInsets.only(top: 35.0, left: 30.0, right: 30.0),
                      child: Form(
                        autovalidate: _autoValidate,
                          key:  formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                onSaved: (value){
                                  this.mail = value.toLowerCase().trim();
                                },
                                validator: (value){
                                  if (EmailValidator.validate(value.trim())){
                                    return null;
                                  } else{
                                    return 'Mail is required';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'EMAIL',
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color:Colors.pink,
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30)
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25.0, top: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        'New to Bunky?',
                                      style: TextStyle(
                                        color: Colors.grey
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pushNamed(this.context, '/register');
                                      },
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              FloatingActionButton(
                                onPressed: (){
                                  if(!formKey.currentState.validate()){
                                    setState(() {
                                      _autoValidate = true;
                                    });
                                    return;
                                  } else {
                                  }
                                  formKey.currentState.save();
                                  setState(() {
                                    _loading = true;
                                  });
                                  submit();
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    try{
      final response = await http.get(
        '$url/loginUser?mail=$mail', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }).timeout(const Duration(seconds: 10));


      if(response.statusCode == 200){
        print("200 OK");
        if(response.body.isEmpty){
          showSnackBar('User Not Found');
        } else {
          var body = json.decode(response.body);
          User user =  User.fromJson(body['user']);
          bool haveApt = body['memberOfApt'];
          if(haveApt){
            getCurrency(user);
          } else {
            Navigator.pushNamed(context, '/newApartment', arguments:
            {
              'user': user,
            });
          }
        }
      } else {
        print('error');
        showSnackBar('Error');
      }
    } catch (_) {
      print('No Internet Connection');
      showSnackBar('No Internet Connection');
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> getCurrency(User user) async {
    try{
      final response = await http.get(
        '$url/aptCurrency?userId=${user.userId}&name=${user.name}&mail=${user.mail}', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },).timeout(const Duration(seconds: 7));


      if(response.statusCode == 200){
        print("200 OK");
        if(response.body.isEmpty){
          showSnackBar('Error');
        } else {
          var currencyJson = json.decode(utf8.decode(response.bodyBytes));
          print(currencyJson);
          print('*********************************************');
          user.setCurrency(currencyJson);
          Navigator.pushReplacementNamed(context, '/home', arguments: {
            'user': user,
            'index': 0,
          });
        }
      } else {
        print('error');
        showSnackBar('Error');
      }
    } catch (_) {
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


