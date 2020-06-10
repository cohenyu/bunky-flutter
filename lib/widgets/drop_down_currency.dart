import 'dart:convert';

import 'package:bunky/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropDownCurrency extends StatefulWidget {
  final Function callback;
  User user;

  DropDownCurrency({this.callback, this.user});

  @override
  _DropDownCurrencyState createState() => _DropDownCurrencyState();
}

class _DropDownCurrencyState extends State<DropDownCurrency> {
  String selected;
  List<String> _dropdownValues = ['\$', '₪', ];


  @override
  void initState() {
    selected = _dropdownValues[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      validator: (value){
        if (value == null) {
          return 'Select a currency';
        }
        return null;
      },
      value: selected,
//      hint: Text('Select a currency'),
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
}
