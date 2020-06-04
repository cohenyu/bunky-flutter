import 'dart:convert';

import 'package:bunky/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropDownNames extends StatefulWidget {
  final Function callback;
  User user;
  DropDownNames({this.callback, this.user});

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
          return 'Select Roommate';
        }
        return null;
      },
      value: selected,
      hint: Text('Select Roommate'),
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
      },).timeout(const Duration(seconds: 6));

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
        }
      } else {
        print('Error');
      }
    } catch (_){
      print('No Internet Connection');
    }
  }
}
