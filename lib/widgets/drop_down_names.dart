import 'dart:convert';

import 'package:bunky/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropDownNames extends StatefulWidget {
  final Function callback;
  User user;
  final scaffoldKey;
  DropDownNames({this.callback, this.user, this.scaffoldKey});

  @override
  _DropDownNamesState createState() => _DropDownNamesState();
}

class _DropDownNamesState extends State<DropDownNames> {
  User selected;

  List<User> _dropdownValues = [];

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      validator: (value){
        if (value == null) {
          return 'Select bunky';
        }
        return null;
      },
      value: selected,
      hint: Text('Select bunky'),
      items: _dropdownValues.map((value) => DropdownMenuItem(
        child: Text(value.name,),
        value: value,
      )).toList(),
      onChanged: (value){
        setState(() {
          selected = value;
          this.widget.callback(value);
        });
      },
      isExpanded: true,
    );
  }

  Future<void> getUsers() async {
    try{
      User user = widget.user;
      final response = await http.get(
          'https://bunkyapp.herokuapp.com/allUsersOfAptByUser?userId=${user.userId}&name=${user.name}&mail=${user.mail}', headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },).timeout(const Duration(seconds: 5));

      if(response.statusCode == 200){

        if(response.body.isNotEmpty){
          List jsonData = jsonDecode(response.body);
          List<User> usersNames = [];
          for(var jsonUser in jsonData){
            User roommate = User.fromJson(jsonUser);
            if(roommate.userId != user.userId){
              usersNames.add(roommate);
            }
          }
          setState(() {
            _dropdownValues = usersNames;
          });
        } else{
          showSnackBar('Error');
        }
      } else {
        showSnackBar('Error');
      }
    } catch (_){
      showSnackBar('No Internet Connection');
    }
  }

  void showSnackBar (String title){
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
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
