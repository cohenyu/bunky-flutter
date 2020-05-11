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
  String selected;

  final List<String> _dropdownValues = [
    "Or",
    "Yuval",
    "Miriel"
  ];


  @override
  Widget build(BuildContext context) {
//    getUsers();
    return DropdownButtonFormField(
      validator: (value){
        print(value);
        if (value == null) {
          return 'Select a roomate';
        }
        return null;
      },
      value: selected,
      hint: Text('select roomate'),
      items: _dropdownValues.map((value) => DropdownMenuItem(
        child: Text(value,),
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

//  Future<void> getUsers() async {
//    try{
////      todo - check if post / put / get ?
//      final response = await http.post(
//          'https://bunkyapp.herokuapp.com/allUsersOfAptByUser', headers: <String, String>{
//        'Content-Type': 'application/json; charset=UTF-8',
//      }, body: jsonEncode({
//        'user': widget.user,
//      }
//      )).timeout(const Duration(seconds: 3));
//      print(jsonDecode(response.body));
//      if(response.statusCode == 200){
//        print("200 OK");
//        if(response.body.isNotEmpty){
//          print(jsonDecode(response.body));
//        }
//      } else {
//        print('Error');
//      }
//    } catch (_){
//      print('No Internet Connection');
//    }
//  }
}
