import 'package:bunky/models/user.dart';
import 'package:bunky/pages/logo.dart';
import 'package:bunky/widgets/custom_shape_clipper.dart';
import 'package:bunky/widgets/drop_down_currency.dart';
import 'package:flutter/material.dart';

class AptSettings extends StatefulWidget {
  @override
  _AptSettingsState createState() => _AptSettingsState();
}

class _AptSettingsState extends State<AptSettings> {
  Map data = {};
  String currency;
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    Logo logo = Logo(title: 'Sign up');
    return Scaffold(
      key: _scaffoldKey,
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
          ListView(
            children: <Widget>[
              logo.getLogo(),
              SizedBox(height: 15.0,),
              Text(
                'Choose a currency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                    color: Colors.black.withOpacity(0.7)
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 130.0, vertical: 10.0),
                child: DropDownCurrency(callback: (symbol){currency = symbol;}, scaffoldKey:_scaffoldKey),
              ),
              SizedBox(height: 30.0,),
              FloatingActionButton(
                onPressed: (){
                  User user = data['user'];
                  user.setCurrency(currency);
                  Navigator.pushNamed(context, '/createApartment', arguments: {
                    'user': data['user'],
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
          ),
        ],
      ),
    );
  }

}
