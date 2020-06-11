import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bunky/models/user.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:bunky/pages/logo.dart';
import 'package:bunky/widgets/custom_shape_clipper.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name;
  String mail;
  bool _loading = false;
  bool _autoValidate = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Logo logo = Logo(title: "Sign up");
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
//        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.teal,
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          color: Colors.black,
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
                    SizedBox(height: 0,),
                    Container(
                      padding: EdgeInsets.only(top: 35.0, left: 30.0, right: 30.0),
                      child: Form(
                          key:  formKey,
                          autovalidate: _autoValidate,
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
                              SizedBox(height: 20,),
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(15),
                                  WhitelistingTextInputFormatter(RegExp('[a-zA-Z0-9 -_`\']')),
                                ],
                                onSaved: (value){
                                  String tmp  = value.trim();
                                  String firstLetter = tmp[0].toUpperCase();
                                  this.name = firstLetter + tmp.substring(1);
                                },
                                validator: (value){
                                  if (value.trim().isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'NAME',
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25.0, top: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Already have an account?',
                                      style: TextStyle(
                                          color: Colors.grey
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Sign in',
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
      final response = await http.post(
          'https://bunkyapp.herokuapp.com/createUser', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, body: jsonEncode({
        'name': name,
        'mail': mail,
      }
      )).timeout(const Duration(seconds: 10));
      setState(() {
        _loading = false;
      });
      if(response.statusCode == 200){
        print("200 OK");
        if(response.body.isEmpty){
          print('the mail already exist');
          showSnackBar('Email Already Exists');
        } else {
          User user =  User.fromJson(json.decode(response.body));
          Navigator.pushReplacementNamed(this.context, '/newApartment', arguments:
          {
            'user': user,
          });
        }
      } else {
        showSnackBar('Error');
      }
    } catch (_){
      print('No Internet Connection');
      showSnackBar('No Internet Connection');
    }
    setState(() {
      _loading = false;
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
