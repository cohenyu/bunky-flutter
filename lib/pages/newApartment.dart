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

  Map data = {};
  final String url = 'https://bunkyapp.herokuapp.com/loginUser';
  User user;
  User futureUser;
  bool firstTime = true;
  
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        data = ModalRoute.of(context).settings.arguments;
        fetchUser();
      });
    });
  }

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
            user == null ? Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: SpinKitThreeBounce(
                  color: Colors.grey[600],
                  size: 25.0,
                ),
              ),
            ): Container(
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
                              Navigator.pushReplacementNamed(context,'/createApartment', arguments: {
                                'user': user,
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Let\'s create new apartment!',
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
                              Navigator.pushReplacementNamed(context, '/connectApartment', arguments: {
                                'user': user,
                              });
                            },
                            icon: Icon(
                              Icons.home,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Already have the code',
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
  
  Future<void> fetchUser() async {
    print(data['mail']);
    print(data['name']);
    final response = await http.post(
        'https://bunkyapp.herokuapp.com/createUser', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode({
      'name': data['name'],
      'mail': data['mail'],
    }
    ));

    if(response.statusCode == 200){
      print("200 OK");
      setState(() {
        print(json.decode(response.body));
        setState(() {
          user =  User.fromJson(json.decode(response.body));
        });
        print('${user.name}   ${user.mail}');
      });
    } else {
      print('somthing went worng');
    }
  }

}


