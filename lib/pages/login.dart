import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:bunky/pages/logo.dart';
import 'package:bunky/widgets/custom_shape_clipper.dart';

// finished
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String name;
  String mail;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Logo logo = Logo();
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
//            crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  logo.getLogo(),
                  SizedBox(height: 0,),
                  Container(
                    padding: EdgeInsets.only(top: 35.0, left: 30.0, right: 30.0),
                    child: Form(
                        key:  formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              onSaved: (value){
                                this.mail = value;
                              },
                              validator: (value){
                                if (EmailValidator.validate(value)){
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
                              onSaved: (value){
                                this.name = value;
                              },
                              validator: (value){
                                if (value.isEmpty) {
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
                            SizedBox(
                              height: 25.0,
                            ),
                            FloatingActionButton(
                              onPressed: (){
                                if(!formKey.currentState.validate()){
                                  return;
                                }
                                formKey.currentState.save();
                                Navigator.pushReplacementNamed(context, '/newApartment', arguments: {
                                  'name': name,
                                  'mail': mail,
                                });
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
    );
  }
}


